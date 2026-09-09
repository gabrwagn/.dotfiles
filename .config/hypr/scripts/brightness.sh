#!/bin/bash
# brightness.sh - Adjust the laptop panel backlight and show the Noctalia OSD.
# Usage: brightness.sh [up|down]
#
# Noctalia cannot drive this itself: when docked, eDP-1 is mirrored onto
# HDMI-A-1, so Hyprland never advertises it as a wl_output and the shell has no
# backlight-capable target (the TV speaks no DDC/CI). So we change brightness
# here and hand Noctalia the resulting value purely for the OSD.

set -euo pipefail

DEV=apple-panel-bl
STEP=5

case "${1:-}" in
    up)   brightnessctl -d "$DEV" set "${STEP}%+" >/dev/null ;;
    down) brightnessctl -d "$DEV" set "${STEP}%-" >/dev/null ;;
    *)    printf 'usage: %s up|down\n' "$0" >&2; exit 2 ;;
esac

cur=$(brightnessctl -d "$DEV" get)
max=$(brightnessctl -d "$DEV" max)
noctalia msg brightness-osd "$(( cur * 100 / max ))" >/dev/null 2>&1 || true
