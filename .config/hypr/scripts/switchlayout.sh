#!/bin/bash
hyprctl switchxkblayout input-remapper-josefadamcik-sofle-forwarded next
# Force XKB update
hyprctl notify 4 5000 "rgb(ff5733)" "Layout switched"
