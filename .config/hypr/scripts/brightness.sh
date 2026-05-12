#!/bin/bash
# brightness.sh - Adjust brightness and show wob OSD
# Usage: brightness.sh [up|down]

WOBSOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"

case "$1" in
  up)
    light -A 5
    ;;
  down)
    light -U 5
    ;;
  *)
    echo "Usage: $0 [up|down]"
    exit 1
    ;;
esac

# Get current brightness as integer (0-100)
current=$(light -G | awk '{printf "%d", $1 + 0.5}')

# Send to wob if the socket exists
if [[ -p "$WOBSOCK" ]]; then
  echo "$current" > "$WOBSOCK"
fi
