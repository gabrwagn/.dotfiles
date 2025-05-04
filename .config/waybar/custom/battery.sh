#!/bin/bash

capacity=$(cat /sys/class/power_supply/macsmc-battery/capacity)
status=$(cat /sys/class/power_supply/macsmc-battery/status)

class=""
if [[ "$status" == "Charging" ]]; then
  icon="󱐋"
elif [[ "$status" == "Not charging" || "$status" == "Full" ]]; then
  icon=""
elif (( capacity <= 10 )); then
  icon=" "
  class="critical"
elif (( capacity <= 15 )); then
  icon=" "
  class="warning"
elif (( capacity <= 25 )); then
  icon=" "
elif (( capacity <= 50 )); then
  icon=" "
elif (( capacity <= 75 )); then
  icon=" "
else
  icon=" "
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"$capacity%\", \"class\": \"$class\"}"
