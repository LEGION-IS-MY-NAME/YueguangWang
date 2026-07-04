# Yueguang Wang

Yueguang Wang packages Moonlight Web Stream as a Home Assistant app. It provides a browser-based Moonlight client for streaming from a Sunshine host.

## Setup

1. Install the app from this repository in Home Assistant.
2. Start the app.
3. Open the web UI from the sidebar or browse to port `8080` on the Home Assistant host.
4. Create the first user. The first created user becomes the admin.
5. Add and pair your Sunshine host from the Moonlight Web interface.

When adding a host, enter only the host name or IP address in the address field, for example `192.168.1.50`. Do not include `http://`, `https://`, a trailing slash, or a path. Leave the port empty for Sunshine's default Moonlight/Gamestream HTTP port, or set it to `47989`. Do not use Sunshine's web UI port.

If pairing fails through the Home Assistant sidebar with a stream abort error, test direct access at `http://HOME_ASSISTANT_IP:8080`. Direct access bypasses Home Assistant ingress while still using the same add-on container and Moonlight data. If direct access pairs correctly, the remaining problem is Home Assistant ingress handling the streamed pairing response.

Runtime data is stored in Home Assistant's app data directory and survives restarts, updates, and backups.

## Options

| Option | Default | Description |
| --- | --- | --- |
| `webrtc_port_range` | `40000:40100` | UDP port range used by WebRTC. |
| `webrtc_nat_1to1_host` | empty | Optional LAN or public IP advertised to WebRTC peers. |
| `log_level` | `info` | Runtime log level. |
| `path_prefix` | empty | Reserved for direct reverse proxy setups. Home Assistant ingress is detected automatically. |

## Network Notes

The app runs with host networking so WebRTC UDP ports can be used directly. If streaming from outside your LAN, configure port forwarding or a TURN server as described by Moonlight Web Stream.

Moonlight Web is bound internally to `127.0.0.1:18081`. The add-on proxy listens on `8080` for Home Assistant ingress and direct access.
