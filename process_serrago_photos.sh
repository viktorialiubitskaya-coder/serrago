#!/bin/bash
# ─────────────────────────────────────────────────────────────────────
# Serrago photo batch processor — FINAL
# ─────────────────────────────────────────────────────────────────────
# Selects 24 best photos from 67 Instagram sources, crops text overlays
# where needed, renames to semantic names, outputs WebP + JPG at
# 1600px max width for production use.
#
# Requirements: ImageMagick — install on Mac: `brew install imagemagick`
# Usage: place all dish_*.jpg in ./source/ and run `bash process_serrago_photos.sh`
# Output: ./img/ with WebP (modern) + JPG (fallback) at ~80-85% quality
# ─────────────────────────────────────────────────────────────────────

set -e

SOURCE_DIR="./source"
OUTPUT_DIR="./img"
MAX_WIDTH=1600
WEBP_QUALITY=82
JPG_QUALITY=85

mkdir -p "$OUTPUT_DIR"

# Detect ImageMagick — v7 uses magick, v6 uses convert
if command -v magick &> /dev/null; then
  IM="magick"
elif command -v convert &> /dev/null; then
  IM="convert"
else
  echo "ERROR: ImageMagick not found. Install with: brew install imagemagick"
  exit 1
fi
echo "Using ImageMagick: $IM"

process_passthrough() {
  local src="$1"
  local out="$2"
  echo "  → $src → $out"

  $IM "$SOURCE_DIR/$src" -strip -auto-orient \
    -resize "${MAX_WIDTH}x${MAX_WIDTH}>" \
    -quality $JPG_QUALITY "$OUTPUT_DIR/$out.jpg"

  $IM "$SOURCE_DIR/$src" -strip -auto-orient \
    -resize "${MAX_WIDTH}x${MAX_WIDTH}>" \
    -quality $WEBP_QUALITY -define webp:method=6 \
    "$OUTPUT_DIR/$out.webp"
}

process_crop_text_bottom() {
  local src="$1"
  local out="$2"
  echo "  → crop bottom: $src → $out"

  local dims=$(identify -format "%w %h" "$SOURCE_DIR/$src")
  local w=$(echo $dims | cut -d' ' -f1)
  local h=$(echo $dims | cut -d' ' -f2)
  local crop_h=$(( h * 86 / 100 ))

  $IM "$SOURCE_DIR/$src" -strip -auto-orient \
    -crop "${w}x${crop_h}+0+0" +repage \
    -resize "${MAX_WIDTH}x${MAX_WIDTH}>" \
    -quality $JPG_QUALITY "$OUTPUT_DIR/$out.jpg"

  $IM "$SOURCE_DIR/$src" -strip -auto-orient \
    -crop "${w}x${crop_h}+0+0" +repage \
    -resize "${MAX_WIDTH}x${MAX_WIDTH}>" \
    -quality $WEBP_QUALITY -define webp:method=6 \
    "$OUTPUT_DIR/$out.webp"
}

echo ""
echo "━━━ PIATTI (8 dishes for carousel) ━━━"
process_passthrough  "dish_034_L32_2023-06-16_side.jpg"  "tataki-tonno"
process_passthrough  "dish_024_L34_2022-06-20_side.jpg"  "tonno-sesamo"
process_passthrough  "dish_036_L32_2023-06-16_side.jpg"  "gamberi-pistacchio"
process_passthrough  "dish_063_L27_2023-07-01_main.jpg"  "crudo-misto"
process_passthrough  "dish_057_L29_2023-02-17_main.jpg"  "tartare-pesce"
process_passthrough  "dish_043_L32_2023-06-16_side.jpg"  "gamberi-finocchi"
process_passthrough  "dish_070_L26_2022-11-03_main.jpg"  "carpaccio-cinghiale"
process_passthrough  "dish_101_L22_2022-10-04_side.jpg"  "gamberoni-saltati"

echo ""
echo "━━━ LO CHEF (3 photos) ━━━"
process_passthrough  "dish_007_L49_2023-12-31_main.jpg"  "chef-giuseppe"
process_passthrough  "dish_017_L34_2023-09-09_side.jpg"  "pesce-fresco"
process_passthrough  "dish_082_L26_2022-07-17_side.jpg"  "plating-service"

echo ""
echo "━━━ CHEF'S TABLE (parallax) ━━━"
process_passthrough  "dish_054_L30_2022-12-08_side.jpg"  "chefs-table"

echo ""
echo "━━━ GALLERIA (8 editorial) ━━━"
process_passthrough        "dish_083_L26_2022-07-17_side.jpg"  "gallery-salumi-mare"
process_passthrough        "dish_037_L32_2023-06-16_side.jpg"  "gallery-zucchine-arrotolate"
process_passthrough        "dish_062_L29_2022-10-21_main.jpg"  "gallery-degustazione"
process_passthrough        "dish_079_L26_2022-07-17_side.jpg"  "gallery-pesce-pietra"
process_crop_text_bottom   "dish_100_L22_2022-10-04_side.jpg"  "gallery-polpette-baccala"
process_passthrough        "dish_028_L33_2023-08-04_side.jpg"  "gallery-gambero-pomodorini"
process_passthrough        "dish_085_L26_2022-07-17_side.jpg"  "gallery-crudo-totale"
process_passthrough        "dish_027_L33_2023-08-04_side.jpg"  "gallery-polipo-fichi"

echo ""
echo "━━━ LA SALA (4 atmosphere) ━━━"
process_passthrough  "dish_045_L32_2022-08-05_main.jpg"  "sala-terrazza-insegna"
process_passthrough  "dish_084_L26_2022-07-17_side.jpg"  "sala-interno-bonsai"
process_passthrough  "dish_044_L32_2022-08-05_side.jpg"  "sala-terrazza-lunga"
process_passthrough  "dish_127_L16_2022-08-13_side.jpg"  "sala-tavoli"

echo ""
echo "━━━ DONE ━━━"
ls "$OUTPUT_DIR" | wc -l | xargs -I{} echo "Total files: {}"
du -sh "$OUTPUT_DIR" | awk '{print "Total size: " $1}'
echo ""
echo "Output ready in: $OUTPUT_DIR/"
