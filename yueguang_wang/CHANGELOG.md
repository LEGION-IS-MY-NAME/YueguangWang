# Changelog

## 2.10.5

- Add a direct `webui` URL for bypassing Home Assistant ingress during pairing and streaming tests.
- Document direct access as the fallback path for streamed pairing failures.

## 2.10.4

- Disable nginx buffering for streaming API endpoints used by host listing, pairing, and streaming.
- Document the required Sunshine host address format.

## 2.10.3

- Move Moonlight Web's internal bind port to `18081` to avoid host-network conflicts.
- Stop immediately if Moonlight Web exits during startup.

## 2.10.2

- Harden startup by waiting for Moonlight Web before launching the ingress proxy.
- Remove the exposed `bind_address` option so existing installs cannot conflict with the proxy listener.
- Add nginx temp paths and config validation for clearer startup failures.

## 2.10.1

- Fix Home Assistant ingress API calls by injecting the Supervisor ingress path into `config.js`.
- Add nginx as a small ingress-aware front proxy while keeping Moonlight Web mounted at `/` internally.

## 2.10.0

- Package Moonlight Web Stream `v2.10.0` as a Home Assistant app.
- Add Home Assistant ingress, host networking, persistent data storage, and runtime options.
