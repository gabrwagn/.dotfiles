#!/bin/bash
# volume.sh - Adjust volume and show wob OSD
# Usage: volume.sh [up|down|mute]

WOBSOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/wob.sock"

case "$1" in
  up)
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    ;;
  down)
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    ;;
  mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
  *)
    echo "Usage: $0 [up|down|mute]"
    exit 1
    ;;
esac

# If muted, show 0; otherwise show current volume
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
if [[ "$muted" == "yes" ]]; then
  current=0
else
  current=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')
fi

# Send to wob if the socket exists
if [[ -p "$WOBSOCK" ]]; then
  echo "$current" > "$WOBSOCK"
fi
