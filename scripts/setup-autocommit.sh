#!/bin/bash
# Installs the ~/.config auto-commit launchd agent on this machine:
#   1. symlinks the tracked plist into ~/Library/LaunchAgents
#   2. (re)loads the launchd agent
# Idempotent and safe to re-run. Prompts for consent before making changes.
set -euo pipefail

# Resolve the repo root from this script's location (portable across clones).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"

LABEL="com.david.config-autocommit"
PLIST_SRC="$REPO/launchd/$LABEL.plist"
LA_DIR="$HOME/Library/LaunchAgents"
LINK="$LA_DIR/$LABEL.plist"
UID_NUM="$(id -u)"

# --- preflight ---------------------------------------------------------------
if [[ ! -f "$PLIST_SRC" ]]; then
  echo "error: plist not found at $PLIST_SRC" >&2
  exit 1
fi

echo "This will set up auto-commit for: $REPO"
echo
echo "  • symlink: $LINK"
echo "            -> $PLIST_SRC"
echo "  • (re)load launchd agent: $LABEL"
echo

# --- consent -----------------------------------------------------------------
read -r -p "Proceed? [y/N] " reply </dev/tty
case "$reply" in
  [yY]|[yY][eE][sS]) ;;
  *) echo "Aborted. No changes made."; exit 0 ;;
esac

# --- install -----------------------------------------------------------------
mkdir -p "$LA_DIR"
ln -sfn "$PLIST_SRC" "$LINK"
echo "✓ symlink created"

# Reload cleanly: ignore failure if not currently loaded.
launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$UID_NUM" "$LINK"
echo "✓ launchd agent loaded"

echo
if launchctl print "gui/$UID_NUM/$LABEL" >/dev/null 2>&1; then
  echo "Done. Auto-commit is active."
else
  echo "warning: agent did not register — check 'launchctl print gui/$UID_NUM/$LABEL'" >&2
  exit 1
fi
