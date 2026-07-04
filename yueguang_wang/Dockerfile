FROM ubuntu:24.04

ARG BUILD_ARCH=amd64
ARG MOONLIGHT_WEB_VERSION=v2.10.0

ENV MOONLIGHT_WEB_PATH=/moonlight-web
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR ${MOONLIGHT_WEB_PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl jq nginx tar \
    && rm -rf /var/lib/apt/lists/*

RUN case "${BUILD_ARCH}" in \
        amd64) target="x86_64-unknown-linux-gnu" ;; \
        aarch64) target="aarch64-unknown-linux-gnu" ;; \
        *) echo "Unsupported Home Assistant architecture: ${BUILD_ARCH}" >&2; exit 1 ;; \
    esac \
    && curl -fsSL \
        "https://github.com/MrCreativ3001/moonlight-web-stream/releases/download/${MOONLIGHT_WEB_VERSION}/moonlight-web-${target}.tar.gz" \
        -o /tmp/app.tar.gz \
    && tar -xzf /tmp/app.tar.gz --strip-components=1 -C "${MOONLIGHT_WEB_PATH}" \
    && rm /tmp/app.tar.gz \
    && chmod +x "${MOONLIGHT_WEB_PATH}/web-server" "${MOONLIGHT_WEB_PATH}/streamer"

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8080/tcp 40000-40100/udp

CMD ["/run.sh"]
