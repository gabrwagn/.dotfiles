#!/bin/bash

# Check if Bluetooth is enabled
if bluetoothctl show | grep -q "Powered: yes"; then
  icon="" # Bluetooth connected
else
  icon="󰂲" # Bluetooth off
fi

echo "{ \"text\": \"$icon\" }"

