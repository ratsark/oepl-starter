# Plan

## Phase 1: first version (for the first gift)  [drafted, awaiting review]
- [x] README as an invitation to tinker, pointing at the guides
- [x] first-steps: Wi-Fi setup, finding the AP, timezone, weather on the big tag
- [x] content-modes overview
- [x] going-further: Image URL, Json template, push (with examples)
- [x] build-an-ap (from oepl-cc2630-firmware docs/SPAGHETTI_AP.md, minus board records)
- [x] case files + README, upstream MIT notice
- [x] AGENTS.md
- [ ] Owner review; approve MISSION_STATEMENT.md wording; choose a license
- [ ] Create the GitHub repo and push (only after review)
- [ ] QR code for the repo URL, for the gift box

Acceptance: a kit recipient can follow first-steps to weather on a tag without
other help. Verify by walking through it on a freshly flashed AP (setup network
→ Wi-Fi → find by name → timezone → weather).

## Phase 2: move OEPL extras out of oepl-cc2630-firmware
- [ ] Move general tools (welcome_cards.py, display examples) here; personal
      ones (HA, webhooks) to the private repo
- [ ] Leave a pointer in oepl-cc2630-firmware where SPAGHETTI_AP.md was

## Phase 3: centrally hosted content
- [ ] A template (GitHub Actions + Pages) that renders a full-screen weather JPEG
      per location for the 6" tag, consumed via Image URL
- [ ] Verify Image URL end-to-end on a real AP (format, size, 304 handling)

## Phase 4: gift box
- [ ] Printable box for AP, tags, stands, power brick and cable, with the QR code

## Open questions
- License for docs/examples (case files stay MIT per upstream)
- Unverified: whether the full tag UI works while the AP is in setup
  (no-Wi-Fi) mode; whether a renamed AP is reachable by name on common routers
