#!/bin/bash
#
# # Check if Bluetooth is enabled
# if bluetoothctl show | grep -q "Powered: yes"; then
#   icon="" # Bluetooth connected
# else
#   icon="󰂲" # Bluetooth off
# fi
#
# echo "{ \"text\": \"$icon\" }"

# Check if Bluetooth is enabled
if bluetoothctl show | grep -q "Powered: yes"; then
  icon="" # Bluetooth connected
  
  # Check for keyboard battery level
  keyboard_battery=$(upower -d | grep -i "keyboard" -A 20 | grep "percentage:" | head -1 | awk '{print $2}' | tr -d '%')
  
  # If keyboard battery found, show with appropriate battery icon
  if [ -n "$keyboard_battery" ]; then
    if [ "$keyboard_battery" -ge 98 ]; then
      bat_icon="󰥉"
    elif [ "$keyboard_battery" -ge 90 ]; then
      bat_icon="󰥅"
    elif [ "$keyboard_battery" -ge 80 ]; then
      bat_icon="󰥆"
    elif [ "$keyboard_battery" -ge 70 ]; then
      bat_icon="󰥅"
    elif [ "$keyboard_battery" -ge 60 ]; then
      bat_icon="󰥄"
    elif [ "$keyboard_battery" -ge 50 ]; then
      bat_icon="󰥃"
    elif [ "$keyboard_battery" -ge 40 ]; then
      bat_icon="󰥃"
    elif [ "$keyboard_battery" -ge 30 ]; then
      bat_icon="󰥂"
    elif [ "$keyboard_battery" -ge 20 ]; then
      bat_icon="󰥀"
    elif [ "$keyboard_battery" -ge 10 ]; then
      bat_icon="󰤿"
    else
      bat_icon="󰤾"
    fi
    echo "{ \"text\": \"$icon  $bat_icon\", \"tooltip\": \"$keyboard_battery%\",}"
  else
    echo "{ \"text\": \"$icon\" }"
  fi
else
  icon="󰂲" # Bluetooth off
  echo "{ \"text\": \"$icon\" }"
fi
