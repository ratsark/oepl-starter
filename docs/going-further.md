# Going further: your own content

The AP's built-in modes are a start. To show anything you like, there are two
approaches:

- **Pull**: the AP fetches a picture or a drawing recipe from a web address on
  a schedule. Whatever makes the content can live anywhere on the internet.
  **No computer at home needed.**
- **Push**: a computer on your home network sends a picture straight to the AP
  whenever it wants. Instant updates, but that computer has to stay running.

## Pull option 1: Image URL

Set a tag's content to **Image URL**, give it a web address and an interval in
minutes. Every interval, the AP downloads the address and shows it.

What the AP expects:

- **A baseline JPEG** (not PNG, not progressive JPEG).
- **Exactly the tag's resolution.** The AP draws the image from the top-left
  corner and doesn't scale it. The tag's card on the AP's page shows its size,
  e.g. 296×128.
- Colors are mapped to the nearest one the tag can show, usually black, white
  and red (or yellow). Strong, flat colors look best; photos get dithered.

Two features let one URL serve several tags:

- Every request carries an **`X-ESL-MAC`** header with the tag's ID, so a
  server can draw something different for each tag.
- Requests carry **`If-Modified-Since`**, so a server can answer
  `304 Not Modified` and the tag won't redraw (saving battery).

Places to host a picture without running a server:

- **GitHub Actions + GitHub Pages**: a scheduled workflow runs a Python script
  that draws a JPEG and publishes it. It's free. Schedules can run 5–30 minutes
  late, which is fine for weather or a daily quote.
- **Cloudflare Workers, Val Town, Deno Deploy and similar**: draws on
  request, so it's always fresh.
- Any web server you already have.

## Pull option 2: Json template

Set a tag's content to **Json template** with a URL. The AP downloads a JSON
list of drawing commands and draws them itself, in its own fonts. This is
handy when you'd rather produce text than pictures (a tiny serverless function
can return it). Example, [examples/hello.json](../examples/hello.json):

```json
[
  {"box":  [0, 0, 296, 30, "red"]},
  {"text": [148, 4, "Hello!", "fonts/bahnschrift20", "white", 1]},
  {"text": [10, 45, "Drawn by the AP", "fonts/calibrib16", "black"]},
  {"circle": [260, 90, 25, "black"]}
]
```

Commands (coordinates in pixels, origin top-left):

| Command | Arguments |
|---|---|
| `text` | x, y, text, font, color, align (0 left, 1 center, 2 right), size (for `.ttf` fonts), background color |
| `textbox` | x, y, width, height, text, font, color, line height, align: wraps text |
| `box` | x, y, w, h, fill color, [border color, border width] |
| `rbox` | x, y, w, h, corner radius, fill color, [border color, border width] |
| `line` | x1, y1, x2, y2, color |
| `triangle` | x1, y1, x2, y2, x3, y3, color |
| `circle` | x, y, radius, fill color, [border color, border width] |
| `image` | filename on the AP, x, y: a JPEG uploaded to the AP's file system |
| `rotate` | 0–3: rotate the drawing by 90° steps |

Colors: `white`, `black`, `red`, `yellow`, `lightgray`, `darkgray`, or `#rrggbb`.
Fonts on the AP: `fonts/bahnschrift20`, `fonts/bahnschrift30`,
`fonts/bahnschrift70`, `fonts/calibrib16`, `fonts/calibrib30`,
`fonts/REFSAN12`, `fonts/tahoma9`, `fonts/tahoma11`, `fonts/twcondensed20`,
plus the scalable `fonts/Signika-SB.ttf` (give a size).

## Push: send a picture from a script

Any computer on your network can post an image to the AP:

```sh
curl -F mac=00124B00XXXXXXXX -F dither=0 -F file=@picture.jpg http://<ap-address>/imgupload
```

Same rules as Image URL: a baseline JPEG at the tag's exact size. `dither=0`
keeps text crisp; `dither=1` suits photos. The tag's ID (its "MAC") is on its
card on the AP's page. [examples/push_image.py](../examples/push_image.py) draws
a picture with Python and pushes it.

Good homes for a push script:

- **A Raspberry Pi** (a Zero 2 W is plenty) with a cron job.
- **Home Assistant**: there's an
  [OpenEPaperLink integration](https://github.com/OpenEPaperLink/Home_Assistant_Integration)
  that can draw tags from your sensors and automations.
- Your laptop, while it's on.

## Beyond content

- **Build another AP**, or a second one for a different room: [build-an-ap.md](build-an-ap.md).
- **Tag firmware**: the tags run open firmware, and you can change it. Start at
  the [OEPL wiki](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki).
- **The AP's HTTP API**: everything the web page does is plain HTTP; see
  [AGENTS.md](../AGENTS.md).
