#!/bin/bash
max_id=$(hyprctl workspaces -j 2>/dev/null | jq -r 'if length > 0 then [.[].id] | max else 0 end' 2>/dev/null)
max_id=${max_id:-0}
next=$((max_id + 1))
[ "$next" -le 5 ] && hyprctl dispatch workspace "$next"
