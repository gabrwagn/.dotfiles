#!/bin/bash

# Check if Bluetooth is enabled
POWERED=$(dbus-send --system --print-reply \
  --dest=org.bluez /org/bluez/hci0 \
  org.freedesktop.DBus.Properties.Get \
  string:"org.bluez.Adapter1" string:"Powered" 2>/dev/null \
  | grep -o 'true\|false')

if [[ "$POWERED" != "true" ]]; then
  echo '{ "text": "󰂲" }'
  exit 0
fi

icon=$'\U000F00AF'
tooltip=""
alerts=""
worst_level="" # "red", "yellow", or ""

while IFS= read -r device_path; do
  [ -z "$device_path" ] && continue

  # Check if connected
  connected=$(dbus-send --system --print-reply \
    --dest=org.bluez "$device_path" \
    org.freedesktop.DBus.Properties.Get \
    string:"org.bluez.Device1" string:"Connected" 2>/dev/null \
    | grep -o 'true\|false')
  [ "$connected" != "true" ] && continue

  # Get device name
  name=$(dbus-send --system --print-reply \
    --dest=org.bluez "$device_path" \
    org.freedesktop.DBus.Properties.Get \
    string:"org.bluez.Device1" string:"Alias" 2>/dev/null \
    | grep -oP 'string "\K[^"]+')

  # Get device type icon
  dev_icon=$(dbus-send --system --print-reply \
    --dest=org.bluez "$device_path" \
    org.freedesktop.DBus.Properties.Get \
    string:"org.bluez.Device1" string:"Icon" 2>/dev/null \
    | grep -oP 'string "\K[^"]+')

  # Map device type to nerd font icon
  case "$dev_icon" in
    input-keyboard) dev_sym="󰌌" ;;
    input-mouse)    dev_sym="󰍽" ;;
    audio-headset|audio-headphones) dev_sym="󰋋" ;;
    *)              dev_sym="󰂱" ;;
  esac

  # Get battery percentage - prefer upower over D-Bus for accuracy
  # First try matching by MAC address in upower path
  mac=$(echo "$device_path" | grep -oP 'dev_\K[A-F0-9_]+' | tr '_' ':')
  mac_under=$(echo "$mac" | tr ':' '_')
  upower_path=$(upower -e 2>/dev/null | grep -i "$mac_under")

  battery=""
  battery_state=""

  if [ -n "$upower_path" ]; then
    upower_info=$(upower -i "$upower_path" 2>/dev/null)
    battery=$(echo "$upower_info" | grep -oP 'percentage:\s+\K[0-9]+')
    battery_state=$(echo "$upower_info" | grep -oP 'state:\s+\K\S+')
  fi

  # If no upower match by MAC, try matching by model name
  if [ -z "$battery" ] && [ -n "$name" ]; then
    for up in $(upower -e 2>/dev/null); do
      up_model=$(upower -i "$up" 2>/dev/null | grep -oP 'model:\s+\K.+')
      if [ "$up_model" = "$name" ]; then
        upower_info=$(upower -i "$up" 2>/dev/null)
        battery=$(echo "$upower_info" | grep -oP 'percentage:\s+\K[0-9]+')
        battery_state=$(echo "$upower_info" | grep -oP 'state:\s+\K\S+')
        break
      fi
    done
  fi

  # Fall back to D-Bus Battery1
  if [ -z "$battery" ]; then
    battery=$(dbus-send --system --print-reply \
      --dest=org.bluez "$device_path" \
      org.freedesktop.DBus.Properties.Get \
      string:"org.bluez.Battery1" string:"Percentage" 2>/dev/null \
      | grep -oP 'byte \K[0-9]+')
  fi
  if [ -n "$battery" ]; then
    # Battery icon for tooltip
    if [ "$battery" -ge 98 ]; then bi="󰥉"
    elif [ "$battery" -ge 90 ]; then bi="󰥅"
    elif [ "$battery" -ge 80 ]; then bi="󰥆"
    elif [ "$battery" -ge 70 ]; then bi="󰥅"
    elif [ "$battery" -ge 60 ]; then bi="󰥄"
    elif [ "$battery" -ge 50 ]; then bi="󰥃"
    elif [ "$battery" -ge 40 ]; then bi="󰥃"
    elif [ "$battery" -ge 30 ]; then bi="󰥂"
    elif [ "$battery" -ge 20 ]; then bi="󰥀"
    elif [ "$battery" -ge 10 ]; then bi="󰤿"
    else bi="󰤾"
    fi
    tooltip+="${dev_sym} ${name}: ${bi} ${battery}%"
    [ "$battery_state" = "charging" ] && tooltip+=" 󱐋"
    tooltip+="\n"

    # Check thresholds for bar display
    if [ "$battery" -le 10 ]; then
      alerts+=" ${dev_sym}"
      worst_level="red"
    elif [ "$battery" -le 15 ]; then
      alerts+=" ${dev_sym}"
      [ "$worst_level" != "red" ] && worst_level="yellow"
    fi
  else
    tooltip+="${dev_sym} ${name}: no battery info\n"
  fi
done < <(dbus-send --system --print-reply \
  --dest=org.bluez / \
  org.freedesktop.DBus.ObjectManager.GetManagedObjects 2>/dev/null \
  | grep -oP '/org/bluez/hci0/dev_[A-F0-9_]+' | sort -u)

# Remove trailing \n
tooltip="${tooltip%\\n}"

# Build output
if [ -n "$alerts" ]; then
  text="${icon}${alerts}"
  class="$worst_level"
else
  text="$icon"
  class=""
fi

if [ -n "$tooltip" ]; then
  echo "{ \"text\": \"${text}\", \"tooltip\": \"${tooltip}\", \"class\": \"${class}\" }"
else
  echo "{ \"text\": \"${text}\", \"class\": \"${class}\" }"
fi
