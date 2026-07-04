# Yueguang Wang

Yueguang Wang packages Moonlight Web Stream as a Home Assistant app. It provides a browser-based Moonlight client for streaming from a Sunshine host.

## Setup

1. Install the app from this repository in Home Assistant.
2. Start the app.
3. Open the web UI from the sidebar or browse to port `8080` on the Home Assistant host.
4. Create the first user. The first created user becomes the admin.
5. Add and pair your Sunshine host from the Moonlight Web interface.

Runtime data is stored in Home Assistant's app data directory and survives restarts, updates, and backups.

## Options

| Option | Default | Description |
| --- | --- | --- |
| `bind_address` | `0.0.0.0:8080` | Address and port used by the web server. |
| `webrtc_port_range` | `40000:40100` | UDP port range used by WebRTC. |
| `webrtc_nat_1to1_host` | empty | Optional LAN or public IP advertised to WebRTC peers. |
| `log_level` | `info` | Runtime log level. |
| `path_prefix` | empty | Optional URL prefix for reverse proxy setups. Leave empty for normal Home Assistant ingress. |

## Network Notes

The app runs with host networking so WebRTC UDP ports can be used directly. If streaming from outside your LAN, configure port forwarding or a TURN server as described by Moonlight Web Stream.
