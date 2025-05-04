#!/bin/bash

# config
critical_level=90
warning_level=80
critical_color="#B66467"
warning_color="#D9BC8C"
info_color="#E8E3E3"
empty_color="#444444"
total_bars=4
bar_char="▮"
# bar_char="▰"
# bar_char_empty="▱"

# bar_char="|"


usage_percent=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
usage_gb=$(free -h | awk '/Mem:/ {print $3}')
num_filled=$(( (usage_percent * total_bars) / 100 ))
color="$info_color"

if [ "$usage_percent" -ge "$critical_level" ]; then
  color="$critical_color"
  # when using a low number of bars its harder to see when its nearing full
  # overriding to max bars alongside the color makes it clearer
  num_filled=$total_bars
elif [ "$usage_percent" -ge "$warning_level" ]; then
  color="$warning_color"
fi

repeat() {
  local str="$1"
  local times="$2"
  for ((i=0; i<times; i++)); do
    printf "%s" "$str"
  done
}

filled=$(repeat "$bar_char" "$num_filled")
empty=$(repeat "$bar_char" $((total_bars - num_filled)))

json_output='{
  "tooltip": "Memory usage: '"$usage_gb ($usage_percent%)"'",
  "text": "<span color=\"'$color'\">'$filled'</span><span color=\"'$empty_color'\">'$empty'</span>"
}'

# need to remove json newlines for waybar
echo "${json_output}" | tr -d '\n'
