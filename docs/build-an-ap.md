# Build a "spaghetti" AP (ESP32-S3 + ESP32-C6, hand-wired)

This is the AP in your kit: two off-the-shelf dev boards joined by eight jumper
wires, no soldering. The upstream guide is
[Beginners Guide for an easy to build Access Point](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki/Beginners-Guide-for-an-easy-to-build-Access-Point-(aka-spaghetti-AP));
this page adds the exact pin labels, the flashing commands, and the things that
went wrong along the way.

## Parts

- **ESP32-S3 devkit, N16R8** (16 MB flash, 8 MB PSRAM), the kind with two USB-C
  ports labelled `USB` and `COM`. It runs the upstream **Yellow AP** firmware,
  which expects exactly this flash/PSRAM. The Yellow AP also drives a screen and
  an LED on other pins; leaving those unconnected is fine. The devkit's RGB LED
  on GPIO48 matches the build.
- **ESP32-C6-DevKitC-1** (Espressif). Runs the radio firmware; this is the
  802.15.4 side the tags talk to.
- 8 female-to-female jumper wires, and a USB-C **data** cable (see Gotchas).
- Optional: the [printed case](../case/).

## Wiring

S3 GPIO number to the label printed on the C6 header:

| Purpose                     | S3 GPIO | C6 silkscreen |
|-----------------------------|---------|---------------|
| Data, S3 → C6               | 17      | 2             |
| Data, C6 → S3               | 18      | 3             |
| Flashing UART (S3 side)     | 19      | TX            |
| Flashing UART (S3 side)     | 20      | RX            |
| Boot-mode select            | 21      | 9             |
| Reset                       | 47      | RST           |
| Power                       | 3V3     | 3V3           |
| Ground                      | GND     | G             |

On the C6 header, `3V3` and `RST` are the top two pins on the left; `2` and `3`
are near the bottom of the left side; `TX`, `RX` and `9` are on the right, with
`TX`/`RX` just below the top `G`. `RST` is the chip's EN pin and `TX`/`RX` are
GPIO16/17 (UART0); they're labelled by function.

The first two rows plus power and ground are all an AP needs to run. The other
four let the S3 reflash the C6 from its web page later.

The C6 has a small jumper labelled **J5** near its pins. Leave it on: it
connects the board's 3.3 V regulator to the chip. (With power wired 3V3 to 3V3
it's technically optional, but it's needed if you ever power the C6 from its
own USB port.)

Pin source: the upstream
[Access point pinouts](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki/Access-point-pinouts)
table (Yellow AP column vs ESP32-C6 column) and `ESP32_AP-Flasher/platformio.ini`
env `ESP32_S3_16_8_YELLOW_AP` (`FLASHER_AP_TXD=17 RXD=18 DEBUG_TXD=19
DEBUG_RXD=20 DEBUG_PROG=21 AP_RESET=47`).

## Flashing

The easiest way is the web flasher at <https://install.openepaperlink.de> in
Chrome or Edge: choose **Yellow AP** for both chips, connect the right board,
and follow the prompts.

With [esptool](https://github.com/espressif/esptool) instead (scriptable,
faster), both images are full flash dumps written at offset 0:

```bash
curl -sLO https://install.openepaperlink.de/bin/current/ESP32_S3_16_8_YELLOW_AP_full.bin
curl -sLO https://install.openepaperlink.de/bin/current/OpenEPaperLink_esp32_C6.bin
```

**S3**: plug in its `COM` port (a CH343 USB-serial chip):

```bash
esptool --port <port> flash-id          # expect 16MB, Embedded PSRAM 8MB
esptool --port <port> --baud 921600 --after hard-reset \
    write-flash 0x0 ESP32_S3_16_8_YELLOW_AP_full.bin
```

**C6**: plug in its `UART` port (a CP2102N). Flash it **before wiring it to the
S3**, or with the four signal wires pulled (see Gotchas):

```bash
esptool --port <port> --baud 921600 --after hard-reset \
    write-flash 0x0 OpenEPaperLink_esp32_C6.bin
```

Ports look like `/dev/cu.usbmodem…` / `/dev/cu.usbserial-…` on a Mac,
`/dev/ttyACM0` / `/dev/ttyUSB0` on Linux, `COM3` etc. on Windows.

If esptool reports "Wrong boot mode" or "No serial data received": hold `BOOT`,
tap `RST`, release `BOOT`, then rerun with `--before no-reset`.

## Bring-up

1. Wire per the table, power the S3 over USB (the C6 runs off the S3's 3V3).
2. Follow [first steps](first-steps.md) to put it on Wi-Fi.
3. Check `http://<ip>/sysinfo`: `"ap_version"` must be non-zero. Zero means
   the S3 isn't hearing the C6: check the 17↔2 and 18↔3 wires are crossed as
   in the table.

The AP's own setup network (`OpenEPaperLink`, 192.168.4.1) only offers the
Wi-Fi setup page; the tag list and settings appear once it has joined a
network. To test an AP you're giving away, put it on your own Wi-Fi first,
then clear its Wi-Fi before handing it over (see Gotchas).

The AP defaults to radio **channel 11**. A tag only re-scans when it loses its
AP, so a tag moves to a new AP when its batteries are pulled near that one, or
when it's carried out of range of its old one.

## Gotchas

- **Charge-only USB-C cables.** If the computer doesn't see the board at all
  (not even an unknown device), swap the cable before suspecting drivers.
- **Flashing the C6 over USB while wired to the S3 fails.** The C6's 3.3 V
  back-feeds the S3 through the power wire, the S3 boots and drives the C6's
  RST/9/TX/RX lines, and the handshake dies. Pull those four wires at the C6
  (leave 3V3, G, 2, 3), do the BOOT/RST dance, flash with `--before no-reset`.
- **The AP's own C6 updater** (`POST /update_c6`) failed with "Connection to the
  C6 failed" on one AP; flashing the C6 over USB worked. Watch updates live on
  `ws://<ip>/ws`.
- **Clear your Wi-Fi before giving an AP away.** The AP's web page has no
  login, and `/get_wifi_config` returns the saved network name *and password*
  in plain text to anyone who can reach it. To forget the network but keep the
  tags and settings, either hold `BOOT` on the S3 for 5 seconds while it powers
  up, or run
  `curl -X POST -H 'Content-Type: application/json' -d '{"ssid":"","pw":""}' http://<ap>/save_wifi_config`.
  It reboots into setup mode. (Never send `"ssid":"factory"`: that wipes
  everything, tags included.) Without saved Wi-Fi it also falls back to setup
  mode by itself, 15 seconds after failing to connect.
- **Several APs on one network share their tag lists**, and tags on the same
  channel may check in with either. Tags another AP is serving show up as
  "remote" (`isexternal`). That's by design; a tag settles on whichever AP it
  can still hear once you move one.
- **`apstate` isn't in `/sysinfo`** on this build; `ap_version` is the useful
  field.

## Optional: 900 MHz for Chroma tags

The C6 firmware also drives a CC1101 sub-GHz radio for the Chroma tag family,
with no reflash. Wire a **915 MHz** (US) or 868 MHz (EU) CC1101 module to C6
pins 0 (SCLK), 1 (MOSI), 4 (CSn), 5 (GDO0), 6 (GDO2), 7 (MISO), plus 3V3 (the
S3's spare 3V3 pin) and G. A SubGhz channel setting then appears on the AP's
settings page. See the wiki's
[SubGhz pages](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki/Access-point-pinouts)
for module recommendations; cheap generic CC1101 boards are often duds.
