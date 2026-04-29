#!/bin/bash
# track_progress.sh, log today's thesis page count
# Usage: ./track_progress.sh [path/to/main.pdf]
#
# Appends "YYYY-MM-DD,<pages>" to progress.csv. One entry per day, # re-running on the same day overwrites that day's row.

set -e

PDF="${1:-main.pdf}"
LOG="progress.csv"

if [ ! -f "$PDF" ]; then
  echo "Error: $PDF not found. Compile the thesis first (or pass the PDF path as an argument)."
  exit 1
fi

if ! command -v pdfinfo >/dev/null 2>&1; then
  echo "Error: pdfinfo not installed. Install poppler-utils (Linux) or poppler (macOS)."
  exit 1
fi

PAGES=$(pdfinfo "$PDF" | awk '/^Pages:/ {print $2}')
TODAY=$(date +%Y-%m-%d)

if [ ! -f "$LOG" ]; then
  echo "date,pages" > "$LOG"
fi

# replace today's row if it exists, otherwise append
if grep -q "^${TODAY}," "$LOG"; then
  # portable in-place edit (works on macOS and Linux)
  awk -v d="$TODAY" -v p="$PAGES" -F, 'BEGIN{OFS=","} $1==d {$2=p} {print}' "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
  echo "Updated ${TODAY}: ${PAGES} pages"
else
  echo "${TODAY},${PAGES}" >> "$LOG"
  echo "Logged ${TODAY}: ${PAGES} pages"
fi
