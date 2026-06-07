#!/bin/bash
# Installs the ~/.config auto-commit launchd agent on this machine:
#   1. renders the tracked plist template with THIS machine's paths
#   2. writes it to ~/Library/LaunchAgents  (machine-local, not tracked)
#   3. (re)loads the launchd agent
# Username/path-independent and idempotent. Prompts for consent before changes.
set -euo pipefail

# Resolve the repo root from this script's location (portable across clones/users).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"

LABEL="com.david.config-autocommit"
TEMPLATE="$REPO/launchd/$LABEL.plist.template"
LA_DIR="$HOME/Library/LaunchAgents"
RENDERED="$LA_DIR/$LABEL.plist"
UID_NUM="$(id -u)"

# --- preflight ---------------------------------------------------------------
if [[ ! -f "$TEMPLATE" ]]; then
  echo "error: template not found at $TEMPLATE" >&2
  exit 1
fi

echo "This will set up auto-commit for repo: $REPO"
echo
echo "  • render template:  $TEMPLATE"
echo "    with REPO=$REPO  HOME=$HOME"
echo "  • write agent to:   $RENDERED"
echo "  • (re)load launchd agent: $LABEL"
echo

# --- consent -----------------------------------------------------------------
read -r -p "Proceed? [y/N] " reply </dev/tty
case "$reply" in
  [yY]|[yY][eE][sS]) ;;
  *) echo "Aborted. No changes made."; exit 0 ;;
esac

# --- install -----------------------------------------------------------------
mkdir -p "$LA_DIR" "$HOME/Library/Logs"

# Remove any old symlink/file from a previous scheme, then render fresh.
rm -f "$RENDERED"
sed -e "s|__REPO__|$REPO|g" -e "s|__HOME__|$HOME|g" "$TEMPLATE" > "$RENDERED"
echo "✓ agent rendered for this machine"

# Reload cleanly: ignore failure if not currently loaded.
launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$UID_NUM" "$RENDERED"
echo "✓ launchd agent loaded"

echo
if launchctl print "gui/$UID_NUM/$LABEL" >/dev/null 2>&1; then
  echo "Done. Auto-commit is active on this machine."
else
  echo "warning: agent did not register — check 'launchctl print gui/$UID_NUM/$LABEL'" >&2
  exit 1
fi
