#!/bin/bash
# Long-lived recursive FSEvents watcher for ~/.config.
# On ANY change under the repo (except .git/), debounce briefly and run the
# autocommit script. Replaces launchd WatchPaths, which cannot watch a tree
# recursively. Loaded by launchd as a KeepAlive daemon — see
# launchd/com.david.config-autocommit.plist.template
set -u

# launchd hands us a minimal PATH; add Homebrew (Apple Silicon + Intel) so
# fswatch resolves regardless of which Mac this runs on.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # repo root = parent of scripts/
COMMIT="$REPO/scripts/config-autocommit.sh"

FSWATCH="$(command -v fswatch)" || { echo "fswatch not found on PATH" >&2; exit 1; }

# -o                : coalesce events into one line per batch → one commit run per batch
# --latency 1.5     : debounce rapid saves into a single batch
# --recursive       : watch the whole tree (the point of switching off WatchPaths)
# --exclude '\.git/': ignore git's own writes, else commit → .git change → infinite loop
"$FSWATCH" -o --recursive --latency 1.5 --exclude '\.git/' "$REPO" \
  | while read -r _; do "$COMMIT"; done
