#!/bin/bash
# from_overleaf.sh, pull the latest writing changes from Overleaf
# Usage: ./from_overleaf.sh

set -e

# Run a command after printing it (so you learn what's happening)
run() {
  echo ">>> $@"
  "$@"
  echo ""
}

echo "=== Pulling latest changes from Overleaf ==="
echo ""

# Overleaf uses 'master' as its branch name (regardless of what local uses).
run git pull overleaf master

echo "=== Current status ==="
echo ""
run git status -s

echo "Server is up to date with Overleaf."
