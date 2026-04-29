#!/bin/bash
# backup_to_github.sh, push the day's work to GitHub for version control
# Usage: ./backup_to_github.sh "summary of the day's work"
#
# Before pushing, this also:
#   - compiles main.tex to main.pdf (if latexmk or pdflatex is on the server)
#   - track_progress.sh logs today's page count to progress.csv
#   - plot_progress.R regenerates figures/progress.{pdf,png}
#   - update_readme.sh refreshes the README dashboard

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

# --- Compile main.tex to get a fresh main.pdf (non-fatal on failure) ---
echo "=== Compiling main.tex ==="
if [ -f main.tex ]; then
  if command -v latexmk >/dev/null 2>&1; then
    if latexmk -pdf -interaction=nonstopmode -silent main.tex >/dev/null 2>&1; then
      echo "Compiled main.pdf via latexmk."
    else
      echo "(latexmk failed; continuing with the previous main.pdf if any)"
    fi
  elif command -v pdflatex >/dev/null 2>&1; then
    if pdflatex -interaction=nonstopmode -halt-on-error main.tex >/dev/null 2>&1; then
      echo "Compiled main.pdf via pdflatex (single pass; references may be stale)."
    else
      echo "(pdflatex failed; continuing with the previous main.pdf if any)"
    fi
  else
    echo "(no latexmk or pdflatex on PATH; install texlive on the ITB server to enable auto-compile)"
  fi
else
  echo "(no main.tex in this directory)"
fi
echo ""

# --- Update progress log/plot (non-fatal if main.pdf isn't built yet) ---
echo "=== Updating thesis progress ==="
if [ -f main.pdf ] && command -v pdfinfo >/dev/null 2>&1; then
  run ./track_progress.sh main.pdf
  if command -v Rscript >/dev/null 2>&1; then
    run Rscript plot_progress.R progress.csv figures
  else
    echo "(Rscript not found, skipping plot regeneration)"
    echo ""
  fi
else
  echo "(main.pdf or pdfinfo not available, skipping progress tracking)"
  echo ""
fi

# --- Refresh the README dashboard (progress block + chapters list) ---
if [ -f update_readme.sh ]; then
  run ./update_readme.sh
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

run git push github master

echo "Done. Day's work backed up to GitHub."
