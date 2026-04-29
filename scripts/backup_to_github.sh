#!/bin/bash
# backup_to_github.sh — push the day's work to GitHub for version control
# Usage: ./backup_to_github.sh "summary of the day's work"

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
