#!/usr/bin/env bash
SCRIPT="$HOME/.config/waybar/calendar-popup.py"
if pkill -f "python3 $SCRIPT"; then
    exit 0
fi
python3 "$SCRIPT" &
