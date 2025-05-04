#!/bin/bash

# Example output from calcurse -n:
# next appointment:
#  [21:22] Daily standup, this is a description

# settings
SHOW_THRESHOLD=60
NOTIFY_THRESHOLD=2

NOTIFY_OUTPUT=$(calcurse -n | tail -n1)
if [[ -z "$NOTIFY_OUTPUT" ]]; then
  exit 0
fi

# Extract time left (from [HH:MM] format)
TIME_LEFT=$(echo "$NOTIFY_OUTPUT" | awk -F'[][]' '{print $2}')
HOURS_STR=$(echo "$TIME_LEFT" | cut -d':' -f1)
MINUTES_STR=$(echo "$TIME_LEFT" | cut -d':' -f2)
HOURS=${HOURS_STR:-0}
MINUTES=${MINUTES_STR:-0}
TOTAL_MINUTES=$((10#$HOURS * 60 + 10#$MINUTES))

TITLE=$(echo "$NOTIFY_OUTPUT" | cut -d',' -f1 | sed 's/^\s*\[.*\]\s*//')
DESCRIPTION=$(echo "$NOTIFY_OUTPUT" | cut -d',' -f2- | sed 's/^\s*//;s/\s*$//')

if [[ -n "$TOTAL_MINUTES" && "$TOTAL_MINUTES" -le $SHOW_THRESHOLD ]]; then
  echo "󰃭 $TITLE in $TOTAL_MINUTES mins"
fi

if [[ -n "$TOTAL_MINUTES" && "$TOTAL_MINUTES" -le $NOTIFY_THRESHOLD ]]; then
  notify-send "! $TITLE" "\n$DESCRIPTION" --app-name="calcurse"
fi
