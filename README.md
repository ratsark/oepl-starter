# oepl-starter

So someone handed you a small plastic box with a USB-C socket on one end, a
handful of e-paper price tags, and a QR code that brought you here. Good. This
is where you start.

The tags are electronic shelf labels, the kind supermarkets use for prices.
They've been reflashed with open firmware from the
[OpenEPaperLink](https://github.com/OpenEPaperLink/OpenEPaperLink) project (OEPL),
so they now take orders from **your** access point instead of a store's. The
access point (the "AP") is the plastic box: two small circuit boards and a nest
of wires inside. It joins your Wi-Fi, decides what each tag should show, and
beams the pictures to the tags over a low-power radio. A tag sleeps almost all the time, wakes up about once a
minute to ask the AP "anything for me?", and only redraws when there is. That is
why the batteries last for years.

This isn't a finished gadget. It's an invitation to tinker: everything here is
open, hackable, and meant to be broken and fixed again.

## What's in the box

- **Six tags**: two big 6" ones (black, white and red), two wide 2.9" ones and
  two small square 1.6" ones (those four also do yellow).
- **The AP**: the small printed box, with a USB plug and cable to power it.
- **Stands**: a few for a table, a few magnetic ones for the fridge.
- **Spare batteries** for the tags (they come with batteries in).

## Start here

1. **[First steps](docs/first-steps.md)**: plug the AP in, put it on your
   Wi-Fi, and have live weather on every tag in about ten minutes, then a Deep
   Thought on one of them.
2. **[Live displays, ready to use](docs/hosted-views.md)**: weather and Deep
   Thoughts that update themselves. You paste a link into a tag and it stays
   current from then on. East Bay weather in three sizes, a Deep Thought in two.
3. **[What the AP can show by itself](docs/content-modes.md)**: countdowns, QR
   codes, calendars, RSS and more, with no other computer involved.
4. **[Going further](docs/going-further.md)**: draw your own pictures, from a
   cloud script, a Raspberry Pi, or Home Assistant.

## How they're made

Curious what's in the box, or want another one someday? Everything is here.

- **[The AP](docs/build-an-ap.md)**: the two boards, the eight wires between
  them, and how the firmware got on.
- **[The case](case/)**: the printable enclosure it lives in, with a sliding
  lid and no screws.

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

## License

MIT, see [LICENSE](LICENSE). The case keeps hillstub's MIT notice too.
