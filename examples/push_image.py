#!/usr/bin/env python3
"""Draw a picture and push it to one tag through the AP.

    pip install pillow
    python3 push_image.py <ap-address> <tag-mac> <width> <height> "Some text"

The tag's MAC and size are on its card on the AP's web page. The AP wants a
baseline JPEG at exactly the tag's resolution; it maps colors to the nearest
ones the tag can show (black, white, and red or yellow).
"""
import io
import sys
import urllib.request
import uuid

from PIL import Image, ImageDraw, ImageFont


def draw(width, height, text):
    img = Image.new("RGB", (width, height), "white")
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, width, height // 4], fill="red")
    try:
        font = ImageFont.truetype("DejaVuSans-Bold.ttf", height // 5)
    except OSError:
        font = ImageFont.load_default()
    d.text((width // 2, height * 5 // 8), text, fill="black", font=font, anchor="mm")
    return img


def push(ap, mac, img):
    buf = io.BytesIO()
    img.save(buf, "JPEG", quality=95, progressive=False)
    boundary = uuid.uuid4().hex
    parts = []
    for name, value in (("mac", mac), ("dither", "0")):
        parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="{name}"\r\n\r\n{value}\r\n'.encode())
    parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="image.jpg"\r\n'
                 f'Content-Type: image/jpeg\r\n\r\n'.encode() + buf.getvalue() + b"\r\n")
    parts.append(f"--{boundary}--\r\n".encode())
    req = urllib.request.Request(f"http://{ap}/imgupload", data=b"".join(parts),
                                 headers={"Content-Type": f"multipart/form-data; boundary={boundary}"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.status, r.read().decode(errors="replace")


if __name__ == "__main__":
    if len(sys.argv) != 6:
        sys.exit(__doc__)
    ap, mac, w, h, text = sys.argv[1:]
    print(*push(ap, mac.upper(), draw(int(w), int(h), text)))
