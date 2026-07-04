#!/usr/bin/env bash
set -euo pipefail

OPTIONS_PATH=/data/options.json
SERVER_DATA_PATH=/data/server
CONFIG_PATH="${SERVER_DATA_PATH}/config.json"
NGINX_CONFIG_PATH=/tmp/yueguang-wang-nginx.conf

mkdir -p "${SERVER_DATA_PATH}" /config

rm -rf "${MOONLIGHT_WEB_PATH}/server"
ln -s "${SERVER_DATA_PATH}" "${MOONLIGHT_WEB_PATH}/server"

option() {
    local key="$1"
    local fallback="$2"

    if [[ -f "${OPTIONS_PATH}" ]]; then
        jq -r --arg key "${key}" --arg fallback "${fallback}" '.[$key] // $fallback' "${OPTIONS_PATH}"
    else
        printf '%s\n' "${fallback}"
    fi
}

export BIND_ADDRESS
BIND_ADDRESS="127.0.0.1:8081"

export WEBRTC_PORT_RANGE
WEBRTC_PORT_RANGE="$(option webrtc_port_range "40000:40100")"

export LOG_LEVEL
LOG_LEVEL="$(option log_level "info")"

WEBRTC_NAT_1TO1_HOST="$(option webrtc_nat_1to1_host "")"
if [[ -n "${WEBRTC_NAT_1TO1_HOST}" && "${WEBRTC_NAT_1TO1_HOST}" != "null" ]]; then
    export WEBRTC_NAT_1TO1_HOST
fi

cat > "${NGINX_CONFIG_PATH}" <<'EOF'
worker_processes 1;
pid /tmp/nginx.pid;

events {
    worker_connections 1024;
}

http {
    access_log /dev/stdout;
    error_log /dev/stderr info;

    map $http_x_ingress_path $moonlight_path_prefix {
        default $http_x_ingress_path;
        "" "";
    }

    server {
        listen 8080;

        location = /config.js {
            default_type application/javascript;
            add_header Cache-Control "no-store, no-cache, must-revalidate, private";
            add_header Pragma "no-cache";
            add_header Expires "0";
            return 200 "export default {\"path_prefix\":\"$moonlight_path_prefix\"}";
        }

        location /api/host/stream {
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_pass http://127.0.0.1:8081;
        }

        location / {
            proxy_set_header Host $host;
            proxy_pass http://127.0.0.1:8081;
        }
    }
}
EOF

"${MOONLIGHT_WEB_PATH}/web-server" --config-path "${CONFIG_PATH}" run &
app_pid="$!"

trap 'kill "${app_pid}" 2>/dev/null || true' EXIT INT TERM

nginx -c "${NGINX_CONFIG_PATH}" -g 'daemon off;' &
nginx_pid="$!"

wait -n "${app_pid}" "${nginx_pid}"
