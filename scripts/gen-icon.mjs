// Generates assets/icon.png (192x192 RGBA) without any dependencies: node scripts/gen-icon.mjs
import { writeFileSync, mkdirSync } from 'node:fs';
import { crc32, deflateSync } from 'node:zlib';

const W = 192, H = 192, R = 40; // size and corner radius
const px = new Uint8Array(W * H * 4);

function inRoundedRect(x, y) {
  const cx = x < R ? R : x > W - 1 - R ? W - 1 - R : x;
  const cy = y < R ? R : y > H - 1 - R ? H - 1 - R : y;
  return (x - cx) ** 2 + (y - cy) ** 2 <= R * R;
}
// Terminal prompt ">_" made of three strokes.
function inGlyph(x, y) {
  const d = (ax, ay, bx, by) => {
    const t = Math.max(0, Math.min(1, ((x - ax) * (bx - ax) + (y - ay) * (by - ay)) / ((bx - ax) ** 2 + (by - ay) ** 2)));
    return Math.hypot(x - (ax + t * (bx - ax)), y - (ay + t * (by - ay)));
  };
  return d(52, 60, 92, 96) <= 11 || d(92, 96, 52, 132) <= 11 || (x >= 104 && x <= 144 && y >= 122 && y <= 142);
}

for (let y = 0; y < H; y++) {
  for (let x = 0; x < W; x++) {
    const i = (y * W + x) * 4;
    if (!inRoundedRect(x, y)) continue; // transparent corners
    const t = (x + y) / (W + H); // diagonal gradient, orange -> red-orange
    let [r, g, b] = [255, Math.round(140 - 70 * t), Math.round(40 - 20 * t)];
    if (inGlyph(x, y)) [r, g, b] = [255, 255, 255];
    px.set([r, g, b, 255], i);
  }
}

const raw = new Uint8Array(H * (W * 4 + 1));
for (let y = 0; y < H; y++) raw.set(px.subarray(y * W * 4, (y + 1) * W * 4), y * (W * 4 + 1) + 1); // filter 0

function chunk(type, data) {
  const out = Buffer.alloc(12 + data.length);
  out.writeUInt32BE(data.length, 0);
  out.write(type, 4, 'ascii');
  Buffer.from(data).copy(out, 8);
  out.writeUInt32BE(crc32(out.subarray(4, 8 + data.length)) >>> 0, 8 + data.length);
  return out;
}
const ihdr = Buffer.alloc(13);
ihdr.writeUInt32BE(W, 0);
ihdr.writeUInt32BE(H, 4);
ihdr.set([8, 6, 0, 0, 0], 8); // 8-bit RGBA
const png = Buffer.concat([
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
  chunk('IHDR', ihdr),
  chunk('IDAT', deflateSync(raw, { level: 9 })),
  chunk('IEND', new Uint8Array(0)),
]);
mkdirSync(new URL('../assets/', import.meta.url), { recursive: true });
writeFileSync(new URL('../assets/icon.png', import.meta.url), png);
console.log(`assets/icon.png: ${png.length} bytes`);
