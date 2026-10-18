# First steps

Goal: the AP on your Wi-Fi and live weather on your biggest tag, in about ten
minutes.

## 1. Power the AP

Plug the USB-C cable into the port on the end of the case, then into any USB
power brick. The tags already have batteries in them and know how to find
this AP; they'll check in by themselves once it's running.

## 2. Put it on your Wi-Fi

The first time it boots, the AP has no Wi-Fi details, so it creates its own
open network instead.

1. On your phone or laptop, join the Wi-Fi network **`OpenEPaperLink`**.
2. Open **http://192.168.4.1/setup** in a browser.
3. Pick your home network and enter its password. The AP only speaks
   **2.4 GHz** Wi-Fi. If your router splits 2.4 and 5 GHz into separate names,
   pick the 2.4 GHz one. Check the spelling; a typo leaves the AP stuck in
   setup mode, and you can just start again from step 1.
4. The AP reboots and joins your network. Rejoin your normal Wi-Fi.

## 3. Find the AP on your network

The AP gets a new address from your router. To find it:

- **Try `http://openepaperlink/`** first. Kits come with the AP named
  `OpenEPaperLink`, and many home routers let you reach a device by its name
  (some want `http://openepaperlink.lan/` or `.home`). Plain
  `openepaperlink.local` does **not** work; the AP doesn't announce itself
  that way.
- **Router's device list**: look in your router's app or admin page for a
  device named `OpenEPaperLink` (or `OpenEpaperLink-XXXX` on an AP that
  wasn't renamed).
- **Network scanner**: an app like Fing (phone) or `nmap -sn 192.168.1.0/24`
  (laptop, adjust to your network) will list it.

Open `http://<that address>/` and you should see the AP's page, with a card for
each tag.

**Bookmark it.** Most routers keep giving the same device the same address.
You can also reserve one for it in your router's settings so it never moves.

## 4. Set the timezone

On the AP's page, open **Settings** and set the timezone. The default is
Central European time, so clocks and forecasts will be off until you change it.
For US Pacific time, use `PST8PDT,M3.2.0,M11.1.0`. Other zones:
[POSIX TZ strings](https://github.com/nayarsystems/posix_tz_db/blob/master/zones.csv).

## 5. Weather on the big tag

1. On the AP's page, click the card for your largest tag.
2. Set **Content** to **Weather forecast** (or **Current weather**).
3. Type a location, like `Berkeley, CA`, and pick units.
4. Save.

The AP looks up the forecast, draws it, and queues it for the tag. The tag
picks it up the next time it checks in, usually within a minute, and the
screen flashes while it redraws (that's normal for e-paper). From then on
it updates by itself.

## Now what?

- Try the other [content modes](content-modes.md) on the other tags.
- Give each tag a name: click its card and fill in **Alias**.
- Ready to draw your own stuff? See [going further](going-further.md).

## If something's off

- **No `OpenEPaperLink` network appears**: the AP may already have Wi-Fi details
  saved. Look for it on your router instead (step 3).
- **A tag never updates**: the tag card shows when it last checked in. Tags
  check in about once a minute. If one hasn't for a while, take its batteries
  out for ten seconds and put them back; it'll search for the AP again.
- **Weather shows the wrong times**: the timezone (step 4).
