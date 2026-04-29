#!/bin/bash
# update_readme.sh, regenerate the thesis README dashboard
# Usage: ./update_readme.sh
#
# Fills two auto-generated regions of README.md, marked with:
#   <!-- progress:start -->  ...  <!-- progress:end -->
#   <!-- chapters:start -->  ...  <!-- chapters:end -->
# Anything outside those markers is left untouched, so you can edit the rest by hand.

set -e

README="README.md"
if [ ! -f "$README" ]; then
  echo "No README.md in $(pwd). Copy templates/thesis-README.md from the tutorial first."
  exit 0
fi

# --- Progress section ---
PAGES="(no pages logged yet, run ./track_progress.sh after compiling main.pdf)"
LAST_DATE=""
if [ -f progress.csv ] && [ "$(wc -l < progress.csv)" -gt 1 ]; then
  LAST_LINE=$(tail -1 progress.csv)
  LAST_DATE=$(echo "$LAST_LINE" | cut -d, -f1)
  LAST_PAGES=$(echo "$LAST_LINE" | cut -d, -f2)
  PAGES="**${LAST_PAGES} pages** as of ${LAST_DATE}"
fi

PROGRESS_BLOCK=$(cat <<EOF
<!-- progress:start -->
## Progress

${PAGES}

![Progress chart](figures/progress.png)
<!-- progress:end -->
EOF
)

# --- Chapters section ---
CHAPTERS_BLOCK_BODY="(no chapters/ directory found)"
if [ -d chapters ]; then
  CHAPTERS_BLOCK_BODY=$(
    for f in chapters/*.tex; do
      [ -f "$f" ] || continue
      base=$(basename "$f" .tex)
      title=$(echo "$base" | sed -E 's/^[0-9]+[a-z]?_//' | tr '_' ' ')
      echo "- [\`${base}\`](${f}), ${title}"
    done
  )
fi

CHAPTERS_BLOCK=$(cat <<EOF
<!-- chapters:start -->
## Chapters

${CHAPTERS_BLOCK_BODY}
<!-- chapters:end -->
EOF
)

# --- Splice into README using awk ---
awk -v prog="$PROGRESS_BLOCK" -v chap="$CHAPTERS_BLOCK" '
  /<!-- progress:start -->/  { print prog; in_prog = 1; next }
  /<!-- progress:end -->/    { in_prog = 0; next }
  /<!-- chapters:start -->/  { print chap; in_chap = 1; next }
  /<!-- chapters:end -->/    { in_chap = 0; next }
  !in_prog && !in_chap       { print }
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "Updated README.md (progress + chapters)."
