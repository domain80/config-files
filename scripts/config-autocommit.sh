#!/bin/bash
# Auto-commit + push ~/.config changes.
# Invoked by launchd: instantly via WatchPaths, plus a periodic safety-net.
# Designed to be cheap: exits immediately when there is nothing to commit.
set -u
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

REPO="$HOME/.config"
GIT="/usr/bin/git"
LOG="$HOME/Library/Logs/config-autocommit.log"   # outside the repo, never committed

# Single-instance lock so a WatchPaths run and the timer run can't overlap.
LOCK="/tmp/config-autocommit.lock"
mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

cd "$REPO" || exit 0

# Stage everything that is tracked / whitelisted by .gitignore.
"$GIT" add -A

# Nothing staged? Cheap no-op exit (this is the common case on a watch tick).
"$GIT" diff --cached --quiet && exit 0

ts="$(date '+%Y-%m-%d %H:%M:%S')"
"$GIT" commit -q -m "auto: config sync $ts" >>"$LOG" 2>&1

# Push via the alias remote — non-interactive, no ssh-agent required.
# A failed push (e.g. offline) is non-fatal; the next run pushes everything pending.
if GIT_SSH_COMMAND='ssh -o BatchMode=yes -o ConnectTimeout=10' "$GIT" push -q origin main >>"$LOG" 2>&1; then
  echo "$ts  committed + pushed" >>"$LOG"
else
  echo "$ts  committed; push FAILED (will retry on next change)" >>"$LOG"
fi
