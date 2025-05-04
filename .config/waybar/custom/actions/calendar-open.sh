#!/bin/bash

# Example output from calcurse -n:
# next appointment:
#  [21:22] Daily standup, this is a description

NOTIFY_OUTPUT=$(calcurse -n | tail -n1)
if [[ -z "$NOTIFY_OUTPUT" ]]; then
  exit 0
fi

URL=$(echo "$NOTIFY_OUTPUT" | rg -o 'https://[^ >]+')

if [[ -n "$URL" ]]; then
  # Open the URL in the default browser
  xdg-open "$URL" &
else
  # If no URL is found, you can handle it here (optional)
  alacritty -e calcurse
fi
