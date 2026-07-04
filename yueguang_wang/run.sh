#!/usr/bin/env bash
set -euo pipefail

OPTIONS_PATH=/data/options.json
SERVER_DATA_PATH=/data/server
CONFIG_PATH="${SERVER_DATA_PATH}/config.json"

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
BIND_ADDRESS="$(option bind_address "0.0.0.0:8080")"

export WEBRTC_PORT_RANGE
WEBRTC_PORT_RANGE="$(option webrtc_port_range "40000:40100")"

export LOG_LEVEL
LOG_LEVEL="$(option log_level "info")"

PATH_PREFIX="$(option path_prefix "")"
if [[ -n "${PATH_PREFIX}" && "${PATH_PREFIX}" != "null" ]]; then
    export PATH_PREFIX
fi

WEBRTC_NAT_1TO1_HOST="$(option webrtc_nat_1to1_host "")"
if [[ -n "${WEBRTC_NAT_1TO1_HOST}" && "${WEBRTC_NAT_1TO1_HOST}" != "null" ]]; then
    export WEBRTC_NAT_1TO1_HOST
fi

exec "${MOONLIGHT_WEB_PATH}/web-server" --config-path "${CONFIG_PATH}" run
