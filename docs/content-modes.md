# What the AP can show by itself

Every tag has a **Content** setting on the AP's web page. Most modes are drawn
by the AP itself and refreshed on a schedule. Nothing else needs to be
running in your house.

| Mode | What it shows | Good for |
|---|---|---|
| **Current weather** | Temperature and conditions now | Small tags |
| **Weather forecast** | Several days ahead | The big tag |
| **Current date** | Today's date | Any tag |
| **Count days / Count hours** | A countdown or count-up, turning red past a threshold you set | "Days until vacation", "days since the cat was fed" |
| **RSS feed** | Latest headlines from any feed URL | News, blogs, GitHub releases |
| **Google calendar** | Your upcoming events | A desk tag. Needs a small Google Apps Script; the AP's page links instructions |
| **QR code** | Any text or URL as a QR code | Guest Wi-Fi, a link |
| **Image URL** | Downloads a picture from a web address every N minutes | Your own content drawn anywhere, see [going further](going-further.md) |
| **Json template** | Downloads a list of drawing commands from a web address | Your own layouts, see [going further](going-further.md) |
| **Static image** | A picture you upload once | Art, a photo, a sign |
| **Display a copy** | Mirrors another tag | Two tags showing the same thing |
| **Access point info** | The AP's own IP address and status | Finding the AP when you've lost it |

Modes that aren't really "content": **Set NFC URL** (what a phone sees when it
taps an NFC-equipped tag), **Firmware update**, **Send command**, **Set tag
config**, **Send custom LUT** (display waveform tuning). Leave these alone until
you know you want them.

## Tips

- E-paper only uses power when it changes, so a tag that refreshes every
  minute drains its batteries much faster than one that refreshes hourly.
  Weather every 30–60 minutes is plenty.
- Colors: many tags can show red or yellow as well as black and white, and the
  AP uses them where it makes sense.
- The full list, with all options, is on the OEPL wiki:
  [Content modes](https://github.com/OpenEPaperLink/OpenEPaperLink/wiki).
