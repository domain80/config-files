#!/bin/bash
# One-shot setup for ~/.config on a machine. Does everything behind one consent prompt:
#   1. point iTerm2 at the tracked settings folder (iterm2/)
#   2. install the auto-commit launchd agent (render plist for this machine + load it)
# Username/path-independent and idempotent. Safe to re-run.
set -euo pipefail

# Resolve repo root from this script's location (portable across clones/users).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$SCRIPT_DIR")"

# --- auto-commit bits ---
LABEL="com.david.config-autocommit"
TEMPLATE="$REPO/launchd/$LABEL.plist.template"
LA_DIR="$HOME/Library/LaunchAgents"
RENDERED="$LA_DIR/$LABEL.plist"
UID_NUM="$(id -u)"

# --- iTerm2 bits ---
ITERM_DOMAIN="com.googlecode.iterm2"
ITERM_FOLDER="$REPO/iterm2"

# --- VS Code bits ---
VSCODE_REPO="$REPO/vscode"
VSCODE_USER="$HOME/Library/Application Support/Code/User"
VSCODE_FILES=(settings.json keybindings.json)

# --- preflight ---------------------------------------------------------------
[[ -f "$TEMPLATE" ]]    || { echo "error: agent template not found at $TEMPLATE" >&2; exit 1; }
[[ -d "$ITERM_FOLDER" ]] || { echo "error: iTerm2 folder not found at $ITERM_FOLDER" >&2; exit 1; }
[[ -d "$VSCODE_REPO" ]]  || { echo "error: vscode folder not found at $VSCODE_REPO" >&2; exit 1; }

echo "This will configure this machine from repo: $REPO"
echo
echo "  iTerm2:"
echo "    • load settings from custom folder: $ITERM_FOLDER"
echo "  VS Code:"
echo "    • symlink ${VSCODE_FILES[*]} into $VSCODE_USER"
echo "  Auto-commit:"
echo "    • render launchd agent (REPO=$REPO  HOME=$HOME)"
echo "    • write + load: $RENDERED"
echo

# --- consent -----------------------------------------------------------------
# Read from the controlling terminal. EOF (Ctrl-D / non-interactive) -> empty -> abort.
if ! read -r -p "Proceed? [y/N] " reply </dev/tty; then reply=""; fi
case "$reply" in
  [yY]|[yY][eE][sS]) ;;
  *) echo "Aborted. No changes made."; exit 0 ;;
esac

# --- 1. point iTerm2 at the tracked folder -----------------------------------
if pgrep -x iTerm2 >/dev/null 2>&1; then
  echo "note: iTerm2 is running — fully quit it (Cmd-Q) after this so the change sticks."
fi
defaults write "$ITERM_DOMAIN" PrefsCustomFolder -string "$ITERM_FOLDER"
defaults write "$ITERM_DOMAIN" LoadPrefsFromCustomFolder -bool true
echo "✓ iTerm2 pointed at $ITERM_FOLDER"

# --- 2. install the auto-commit agent ----------------------------------------
# The watcher (config-watch.sh) needs fswatch for recursive FSEvents watching.
if ! command -v fswatch >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "Installing fswatch (required by the watcher)…"
    brew install fswatch
  else
    echo "error: Homebrew not found; install fswatch manually: brew install fswatch" >&2
    exit 1
  fi
fi
echo "✓ fswatch present"

mkdir -p "$LA_DIR" "$HOME/Library/Logs"
rm -f "$RENDERED"
sed -e "s|__REPO__|$REPO|g" -e "s|__HOME__|$HOME|g" "$TEMPLATE" > "$RENDERED"
launchctl bootout "gui/$UID_NUM/$LABEL" 2>/dev/null || true
launchctl bootstrap "gui/$UID_NUM" "$RENDERED"
if launchctl print "gui/$UID_NUM/$LABEL" >/dev/null 2>&1; then
  echo "✓ auto-commit agent loaded"
else
  echo "warning: agent did not register — check 'launchctl print gui/$UID_NUM/$LABEL'" >&2
  exit 1
fi

# --- done --------------------------------------------------------------------
echo
echo "Done. Remaining manual bits:"
echo "  • Fully quit (Cmd-Q) and reopen iTerm2 to load your settings."
echo "  • In iTerm2: Settings → General → Settings → confirm 'Save changes: Automatically'."
