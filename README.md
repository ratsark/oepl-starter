# oepl-starter

So someone handed you a little box with a circuit board in it and a few
e-paper price tags. This repo is where you start.

The tags are electronic shelf labels, the kind supermarkets use for prices.
They've been reflashed with open firmware from the
[OpenEPaperLink](https://github.com/OpenEPaperLink/OpenEPaperLink) project (OEPL),
so they now take orders from **your** access point instead of a store's. The
access point (the "AP", the box with two boards and a nest of wires) joins your
Wi-Fi, decides what each tag should show, and beams the pictures to the tags
over a low-power radio. A tag sleeps almost all the time, wakes up about once a
minute to ask the AP "anything for me?", and only redraws when there is. That is
why the batteries last for years.

This isn't a finished gadget. It's an invitation to tinker: everything here is
open, hackable, and meant to be broken and fixed again.

## Start here

1. **[First steps](docs/first-steps.md)**: plug the AP in, put it on your Wi-Fi,
   and get live weather on a tag in about ten minutes.
2. **[What the AP can show by itself](docs/content-modes.md)**: weather, calendar,
   RSS, countdowns, QR codes and more, with no other computer involved.
3. **[Going further](docs/going-further.md)**: draw your own content, from a
   cloud script, a Raspberry Pi, or Home Assistant.

## Make more of them

- **[Build an AP](docs/build-an-ap.md)**: the parts, the eight wires, and how to
  flash both boards.
- **[The case](case/)**: a printable enclosure for that AP, with a sliding lid
  and no screws.

## For AI agents

If you're an agent helping someone with this kit, read [AGENTS.md](AGENTS.md)
first. It covers how to talk to the AP over HTTP, how to push an image, and the
pitfalls.

## Credits

- [OpenEPaperLink](https://github.com/OpenEPaperLink/OpenEPaperLink) and its
  contributors wrote the AP firmware and most tag firmware. This repo only
  collects the notes for getting started.
- The case is derived from hillstub's
  [OpenEPaperLink-Minimal-Spaghetti-AP](https://github.com/hillstub/OpenEPaperLink-Minimal-Spaghetti-AP)
  (MIT, see [case/LICENSE-hillstub](case/LICENSE-hillstub)).
- Firmware for the Solum CC2630-based tags:
  [oepl-cc2630-firmware](https://github.com/ratsark/oepl-cc2630-firmware).
