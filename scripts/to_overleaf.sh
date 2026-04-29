#!/bin/bash
# to_overleaf.sh, push your latest changes (figures, code) to Overleaf
# Usage: ./to_overleaf.sh "your commit message"

set -e

if [ -z "$1" ]; then
  echo "Error: please provide a commit message."
  echo "Usage: ./to_overleaf.sh \"your commit message\""
  exit 1
fi

MESSAGE="$1"

# Run a command after printing it (so you learn what's happening)
run() {
  echo ">>> $@"
  "$@"
  echo ""
}

echo "=== Pushing changes to Overleaf ==="
echo ""

echo "Changes to commit:"
run git status -s

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing new to commit. Pushing existing commits to Overleaf..."
else
  run git add .
  run git commit -m "$MESSAGE"
fi

run git push overleaf master

echo "Done. Switch to Overleaf and recompile to see your changes."
