#!/usr/bin/bash

#Restart Waybar and swaync

killall waybar
killall swaync
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
swaync -s ~/.config/swaync/style.css -c ~/.config/swaync/config.json &
systemctl --user restart kanshi.service
notify-send --app-name=HOME reloaded
