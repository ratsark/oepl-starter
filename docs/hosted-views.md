# Ready-made pictures: weather and Deep Thoughts

The fastest way to get something good-looking on a tag is to point it at a
picture that someone else keeps up to date. These are hosted at
`oepl.ratsark.com`, redrawn on a schedule, and sized for the tags in the kit.
Your AP downloads them itself; nothing runs in your house.

## Set one up

1. On the AP's page, click the tag's card.
2. Set **Content** to **Image URL**.
3. Paste the URL for your tag's size from the table below.
4. Set **Interval** to **5**. The AP checks the picture every 5 minutes and
   only sends it to the tag when it has changed, so the tag's battery doesn't
   care how often the AP looks.
5. Save. The tag redraws at its next check-in, usually within a minute.

## The pictures

| Picture | Tag | URL | Redrawn |
|---|---|---|---|
| Berkeley weather | 6" (600 x 448) | `https://oepl.ratsark.com/weather-berkeley-6in.jpg` | hourly |
| Berkeley weather | 2.9" (384 x 168) | `https://oepl.ratsark.com/weather-berkeley-29in.jpg` | hourly |
| Berkeley weather | 1.6" (200 x 200) | `https://oepl.ratsark.com/weather-berkeley-16in.jpg` | hourly |
| Oakland weather | 6" | `https://oepl.ratsark.com/weather-oakland-6in.jpg` | hourly |
| Oakland weather | 2.9" | `https://oepl.ratsark.com/weather-oakland-29in.jpg` | hourly |
| Oakland weather | 1.6" | `https://oepl.ratsark.com/weather-oakland-16in.jpg` | hourly |
| A Deep Thought, by Jack Handey | 6" | `https://oepl.ratsark.com/deepthought-6in.jpg` | every 4 hours |
| A Deep Thought, by Jack Handey | 2.9" | `https://oepl.ratsark.com/deepthought-29in.jpg` | every 4 hours |

Which tag is which: the 6" is the big one with a red and black display; the
2.9" is the wide one; the 1.6" is the small square one. The 2.9" and 1.6"
pictures use yellow as well as red, because those panels can show it.

The weather is for the East Bay. If you live somewhere else, the AP's own
**Weather forecast** mode works for any town (see [first steps](first-steps.md),
step 5); it just isn't as pretty.

## What's in the weather pictures

Current conditions, today's high and low, and an outlook: on the 6", humidity,
wind, UV, sunrise and sunset, an hourly strip and five days; on the 2.9", four
days; on the 1.6", just the essentials. Data from
[Open-Meteo](https://open-meteo.com/), in °F, Pacific time.

## Behind the curtain

A small script renders the pictures and uploads them to a bucket; the
[source](https://github.com/ratsark/oepl-cc2630-firmware/blob/master/tools/oepl_views.py)
and a note on how it runs are in
[oepl-cc2630-firmware/docs/HOSTED_VIEWS.md](https://github.com/ratsark/oepl-cc2630-firmware/blob/master/docs/HOSTED_VIEWS.md).
If you want your own town, or your own picture of anything at all, that's the
template to copy, and [going further](going-further.md) explains the Image URL
mode in general.
