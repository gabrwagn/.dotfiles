#!/bin/bash

bar=" ▁▂▃▄▅▆▇█"
dict="s/;//g"

bar_length=${#bar}
ascii_max_range=$((bar_length - 1))

for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 20

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = $ascii_max_range
EOF

pkill -f "cava -p $config_file"

cava -p "$config_file" | sed -u "$dict" | sed -u 's/^[ ]*$//g'
