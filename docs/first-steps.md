# First steps

Ten minutes from the box to live weather on every tag. Then a Deep Thought.

> **Got an AI assistant?** If you use Claude Code or something like it, point
> it at this repo and ask it to walk you through these steps. It's
> particularly good at step 3, finding the AP on your network, and at setting
> up the tags: everything the AP's web page does is plain HTTP, and
> [AGENTS.md](../AGENTS.md) tells it how. Working alone is fine too.

## 1. Power the AP

Plug the included cable into the socket on the end of the small box and the
included plug into the wall. That's the AP. The tags already have batteries
in (the loose ones in the box are spares) and find the AP on their own: each
one wakes up, listens for an AP, and attaches itself to the first one that
answers. Nothing to pair.

## 2. Name it, then put it on your Wi-Fi

Fresh out of the box the AP has no Wi-Fi details, so it makes its own open
network. (It also does this whenever it can't reach the Wi-Fi it knows, so
an AP that was tested on someone else's network will offer it too, about
twenty seconds after power-on.)

1. On your phone or laptop, join the Wi-Fi network **`OpenEPaperLink`**.
2. Open **http://192.168.4.1/** and click **Settings**. Two things to set:
   - **Alias**: a short name, letters and digits only, like `oepl`. This
     becomes the AP's name on your home network, which is how you'll find it
     in a moment.
   - **Timezone**: the AP ships thinking it's in Central Europe. For US Pacific
     enter `PST8PDT,M3.2.0,M11.1.0`; other zones are listed
     [here](https://github.com/nayarsystems/posix_tz_db/blob/master/zones.csv).

   Save.
3. Now open **http://192.168.4.1/setup**. Pick your home network and type its
   password. The AP speaks **2.4 GHz** Wi-Fi only; if your router shows
   separate 2.4 and 5 GHz names, pick the 2.4 one. Check the spelling: a typo
   leaves the AP stuck in setup mode, and the fix is just to start again from
   step 1. Leave the static IP fields empty unless you know your network and
   want a fixed address.
4. Save. The AP reboots and joins your network. Rejoin your normal Wi-Fi.

Skipped the alias? The setup page shows the AP's Wi-Fi MAC address at the
top; its name is then `OpenEpaperLink-` plus the last four characters, so
`...:FC:D8` gives `OpenEpaperLink-FCD8`.

## 3. Open the AP's page

In a browser, go to **`http://oepl/`** (or whatever alias you chose). Most
home routers let you reach a device by its name as soon as it has joined.

If that doesn't load:

- Try the name with your router's suffix: `http://oepl.lan/`, `.home`, or
  `.localdomain` are the common ones.
- Look in your router's app or admin page for a device called `oepl`; it will
  show the address. Use `http://<that address>/`.
- Last resort, a network scanner like Fing on a phone lists everything on the
  network.

You should see the AP's page with a card for each tag, and each card's "last
seen" time ticking along. **Bookmark it.** Routers usually keep giving a
device the same address, and you can reserve one in the router's settings so
it never moves.

## 4. Weather on every tag

Start with the weather on *all* the tags. It's the quickest way to see what
each size can do, and it takes a minute per tag.

For each tag:

1. Click its card. The card tells you the tag's size.
2. Set **Content** to **Image URL**.
3. Paste the address for that size:

   | Tag | Berkeley | Oakland |
   |---|---|---|
   | 6" (600 x 448, the big one) | `https://oepl.ratsark.com/weather-berkeley-6in.jpg` | `https://oepl.ratsark.com/weather-oakland-6in.jpg` |
   | 2.9" (384 x 168, the wide one) | `https://oepl.ratsark.com/weather-berkeley-29in.jpg` | `https://oepl.ratsark.com/weather-oakland-29in.jpg` |
   | 1.6" (200 x 200, the small square) | `https://oepl.ratsark.com/weather-berkeley-16in.jpg` | `https://oepl.ratsark.com/weather-oakland-16in.jpg` |

4. Set **Interval** to **5**.
5. Save.

Within a minute or two each tag flashes a few times (that's e-paper redrawing)
and settles on the forecast. The pictures are redrawn hourly on a server and
your AP fetches them; nothing else runs in your house. The full list, including
how they're made, is in [live displays, ready to use](hosted-views.md).

**Not in the East Bay?** The AP can draw its own forecast for any town: set
**Content** to **Weather forecast**, type the town, pick units. Do this on a
**2.9" tag**; the built-in layout is designed for that size and doesn't fit the
6" or the 1.6". For the big tag, see [going further](going-further.md) for
drawing your own, or just enjoy the Berkeley weather.

## 5. A Deep Thought

Now that you've seen the sizes, give one tag something to think about. Click a
6" or 2.9" card, keep **Image URL**, and swap the address for:

| Tag | URL |
|---|---|
| 6" | `https://oepl.ratsark.com/deepthought-6in.jpg` |
| 2.9" | `https://oepl.ratsark.com/deepthought-29in.jpg` |

Interval **5** again. A new thought arrives every four hours.

## Now what?

- Put the tags where you'll see them. The kit has table stands and magnetic
  stands for the fridge.
- Give each tag a name: click its card and fill in **Alias**.
- See what else the AP can draw on its own: [content modes](content-modes.md).
  Countdowns and QR codes are good fun on the small tags.
- Draw your own pictures: [going further](going-further.md).

## If something's off

- **No `OpenEPaperLink` network appears**: give it thirty seconds after
  power-on first. If it still isn't there, the AP has joined a Wi-Fi it already
  knew, perhaps yours: look for it on your router (step 3). If it has joined
  the wrong one, or you want a clean start, wipe its Wi-Fi settings: slide the
  lid off the box, find the two tiny buttons on the larger board next to its
  USB sockets, and with the AP powered up **hold the one marked BOOT for six
  seconds** (don't press RST). The AP forgets its Wi-Fi and the `OpenEPaperLink`
  network appears. Then step 2.
- **A tag never updates**: its card shows when it last checked in. Tags check
  in about once a minute. If one has gone quiet, take its batteries out for
  ten seconds and put them back; it searches for the AP again.
- **Times on the tags are wrong**: the timezone. On the AP's page, **Settings**; see step 2 for the value.
- **The AP's page won't load**: it may have moved address. Step 3 again, then
  reserve its address in your router so it stops happening.
