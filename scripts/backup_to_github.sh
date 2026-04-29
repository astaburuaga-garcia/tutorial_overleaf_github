#!/bin/bash
# backup_to_github.sh — push the day's work to GitHub for version control
# Usage: ./backup_to_github.sh "summary of the day's work"
#
# Before pushing, this also updates the thesis-progress log and plot:
#   - track_progress.sh logs today's page count to progress.csv
#   - plot_progress.R regenerates figures/progress.pdf

set -e

if [ -z "$1" ]; then
  echo "Error: please provide a commit message describing the day's work."
  echo "Usage: ./backup_to_github.sh \"summary of the day's work\""
  exit 1
fi

MESSAGE="$1"

# Run a command after printing it (so you learn what's happening)
run() {
  echo ">>> $@"
  "$@"
  echo ""
}

# --- Update progress log/plot (non-fatal if main.pdf isn't built yet) ---
echo "=== Updating thesis progress ==="
if [ -f main.pdf ] && command -v pdfinfo >/dev/null 2>&1; then
  run ./track_progress.sh main.pdf
  if command -v Rscript >/dev/null 2>&1; then
    run Rscript plot_progress.R progress.csv figures/progress.pdf
  else
    echo "(Rscript not found — skipping plot regeneration)"
    echo ""
  fi
else
  echo "(main.pdf or pdfinfo not available — skipping progress tracking)"
  echo ""
fi

echo "=== Backing up to GitHub ==="
echo ""

echo "Status:"
run git status -s

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing new to commit. Pushing existing commits to GitHub..."
else
  run git add .
  run git commit -m "$MESSAGE"
fi

run git push github main

echo "Done. Day's work backed up to GitHub."
