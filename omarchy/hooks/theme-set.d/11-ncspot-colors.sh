#!/bin/bash
# Update ncspot [theme] section with current Omarchy theme colors

COLORS="$HOME/.config/omarchy/current/theme/colors.toml"
NCSPOT="$HOME/.config/ncspot/config.toml"

[[ -f "$COLORS" ]] || exit 0
[[ -f "$NCSPOT"  ]] || exit 0

get_color() {
  grep -m1 "^$1 *= *" "$COLORS" | sed 's/.*= *"\(.*\)".*/\1/'
}

accent=$(get_color "accent")
foreground=$(get_color "foreground")
background=$(get_color "background")
color0=$(get_color "color0")
color1=$(get_color "color1")
color2=$(get_color "color2")
color3=$(get_color "color3")
color7=$(get_color "color7")

# Strip existing [theme] block, keep everything else
awk '
  /^\[theme\]/ { skip=1; next }
  /^\[/ && skip { skip=0 }
  !skip { print }
' "$NCSPOT" > /tmp/ncspot_notheme.toml

cat >> /tmp/ncspot_notheme.toml <<EOF

[theme]
background          = "$background"
primary             = "$foreground"
secondary           = "$color7"
title               = "$accent"
playing             = "$color2"
playing_selected    = "$color2"
playing_bg          = "$background"
highlight           = "$background"
highlight_bg        = "$accent"
error               = "$color1"
error_bg            = "$background"
statusbar           = "$foreground"
statusbar_progress  = "$accent"
statusbar_bg        = "$color0"
cmdline             = "$foreground"
cmdline_bg          = "$background"
search_match        = "$color3"
EOF

mv /tmp/ncspot_notheme.toml "$NCSPOT"
