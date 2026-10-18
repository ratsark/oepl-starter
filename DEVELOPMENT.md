# Development

Mostly Markdown; edit and preview on GitHub.

## Case

Needs OpenSCAD (2021.01+) and [BOSL2](https://github.com/BelfrySCAD/BOSL2) in
OpenSCAD's library path. Regenerate the STLs after any `.scad` change (commands
in `case/README.md`) and check OpenSCAD reports `Simple: yes` for each part.

## Examples

`examples/push_image.py` needs Python 3 and Pillow:

    python3 examples/push_image.py <ap> <tag-mac> <width> <height> "Hi"

## Checking facts

Claims about the AP should match the OEPL source and, where practical, a
running AP: `curl http://<ap>/sysinfo`, `curl http://<ap>/get_db`,
`curl http://<ap>/content_cards.json | gunzip`.
