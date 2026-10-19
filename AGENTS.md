# Notes for AI agents

You're probably helping someone who was given an OpenEPaperLink kit: a hand-wired
ESP32-S3 + ESP32-C6 access point and a few e-paper tags. The person is likely
a curious tinkerer, not an expert. Start from [docs/first-steps.md](docs/first-steps.md)
if they haven't got the AP on their Wi-Fi yet.

## The AP's HTTP API

Everything the web page does is plain HTTP on the AP, with **no authentication**.
Keep it on the home network; never expose it to the internet. Note that
`GET /get_wifi_config` returns the saved Wi-Fi password in plain text: don't
print or log its output. `<ap>` below is
its IP address, or its DHCP hostname: `OpenEpaperLink-XXXX`, or the AP's alias
(kits are named `OpenEPaperLink`) if one is set in AP settings. mDNS/`.local` isn't
supported.

| Request | What it does |
|---|---|
| `GET /sysinfo` | AP status JSON. `ap_version` non-zero means the radio (C6) is alive |
| `GET /get_db` | All tags as JSON (`tags` array). `?mac=<MAC>` for one tag |
| `POST /imgupload` (multipart: `mac`, `dither`, `file`) | Show a JPEG on a tag. Default `dither` is 1. Optional `ttl`, `alias`, `rotate`, `lut`, `invert`, `contentmode` (default 24, External image) |
| `POST /save_cfg` (multipart) | Set a tag's alias, content mode and its config. Send every field the web UI sends (`mac`, `alias`, `contentmode`, `modecfgjson`, `rotate`, `lut`, `invert`), echoing current values for the ones you don't change |
| `POST /save_apcfg` | AP settings; only fields sent are changed. `timezone` (POSIX TZ string), `alias` (also becomes the AP's network hostname), `channel` |
| `GET /content_cards.json` | The list of content modes and their parameters (gzip-encoded) |
| `ws://<ap>/ws` | Live log and tag check-ins as JSON messages |

Useful tag fields in `get_db`: `mac`, `alias`, `hwType`, `contentMode`,
`modecfgjson` (a JSON string), `lastseen`, `nextcheckin`, `pending` (an image is
queued), `batteryMv`, `RSSI`, `LQI`, `ver` (firmware version). Tag resolution
comes from the hardware type: `resources/tagtypes/<hwType as 2-digit hex>.json`
in the [OEPL repo](https://github.com/OpenEPaperLink/OpenEPaperLink).

## Images

- **Baseline JPEG** at the tag's exact width × height. No PNG, no progressive
  JPEG, no scaling. Mind the tag's rotation.
- `dither=0` for text and graphics, `dither=1` for photos.
- The AP maps colors to what the panel has (black/white plus red or yellow on
  most). Flat, saturated colors render predictably.
- An upload queues the image; the tag fetches it at its next check-in (usually
  under a minute). `pending` in `get_db` goes false once delivered.
- Every redraw costs the tag battery. Don't refresh more often than the content
  changes; hourly is a good default.

See [examples/push_image.py](examples/push_image.py) for a dependency-light
uploader, and [docs/going-further.md](docs/going-further.md) for pull-based
options (Image URL, Json template) that need no always-on computer.

## Pitfalls

- **Rapid writes can reboot the AP.** Space out `save_cfg` / `imgupload` calls by
  a few seconds, and check `/sysinfo` uptime if things go quiet.
- **Don't change a tag's content mode casually.** Uploading an image switches
  the tag to an image mode; a scheduled mode the person set up (weather etc.)
  gets replaced.
- **Timezone defaults to Central European.** If clocks are off, set it.
- **Tags stick to the AP they first found** and only rescan after losing it
  (or a battery pull).
- Before reflashing anything, read [docs/build-an-ap.md](docs/build-an-ap.md)
  Gotchas; the C6 can't be flashed over USB while wired to the S3.

## Upstream docs

- [OEPL wiki](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki)
- [OEPL source](https://github.com/OpenEPaperLink/OpenEPaperLink), especially
  `ESP32_AP-Flasher/src/web.cpp` (HTTP endpoints) and `contentmanager.cpp`
  (content modes, Json template drawing).
