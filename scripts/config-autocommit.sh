#!/bin/bash
# Auto-commit + push ~/.config changes.
# Invoked by launchd: instantly via WatchPaths, plus a periodic safety-net.
# Cheap: exits immediately when there is nothing to commit.
set -u
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

REPO="$HOME/.config"
GIT="/usr/bin/git"
LOG="$HOME/Library/Logs/config-autocommit.log"   # outside the repo, never committed
LOCK="/tmp/config-autocommit.lock"
PENDING="/tmp/config-autocommit.pending"

# Single-instance lock. If another run holds it, leave a marker so the holder
# loops again — this prevents dropping an event that arrives mid-run.
if ! mkdir "$LOCK" 2>/dev/null; then
  : > "$PENDING"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

cd "$REPO" || exit 0

while :; do
  rm -f "$PENDING"

  "$GIT" add -A
  if "$GIT" diff --cached --quiet; then
    # Nothing staged. If a blocked run signalled work arrived, loop once more.
    [ -e "$PENDING" ] && continue
    break
  fi

  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  "$GIT" commit -q -m "auto: config sync $ts" >>"$LOG" 2>&1

  # Push via the alias remote — non-interactive, no ssh-agent required.
  # A failed push (offline) is non-fatal; the next run pushes everything pending.
  if GIT_SSH_COMMAND='ssh -o BatchMode=yes -o ConnectTimeout=10' "$GIT" push -q origin main >>"$LOG" 2>&1; then
    echo "$ts  committed + pushed" >>"$LOG"
  else
    echo "$ts  committed; push FAILED (will retry on next change)" >>"$LOG"
  fi
  # Loop: catch anything that changed during the commit/push window.
done
