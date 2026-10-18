# Architecture

A documentation repo with a few supporting files. No build system.

- `README.md`: the landing page the gift box's QR code points to.
- `docs/`: guides for people, in the order someone meets them:
  `first-steps.md` → `content-modes.md` → `going-further.md`, plus
  `build-an-ap.md` for making more APs.
- `AGENTS.md`: the AP's HTTP API and pitfalls, for AI agents helping a kit owner.
  `CLAUDE.md` imports it.
- `case/`: OpenSCAD source and exported STLs for the AP case. The `.scad` is the
  source of truth; STLs are regenerated from it (see `case/README.md`).
- `examples/`: small, dependency-light scripts and templates people can copy.

Facts about the AP (endpoints, image format, content modes, fonts) come from the
OpenEPaperLink AP source (`ESP32_AP-Flasher/src/web.cpp`, `contentmanager.cpp`,
`makeimage.cpp`, `wifimanager.cpp`) and are checked against a running AP where
possible.

Out of scope: tag firmware (lives in its own repos), and anything specific to
one household: board serials, gift records, webhook URLs, Home Assistant
details. Those go in a private repo.
