#!/bin/bash

bat=/sys/class/power_supply/macsmc-battery
if [[ ! -d "$bat" ]]; then
  echo "{}"
  exit 0
fi

capacity=$(cat "$bat/capacity")
status=$(cat "$bat/status")

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
