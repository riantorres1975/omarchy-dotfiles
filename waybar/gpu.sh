#!/usr/bin/env bash
GPU=/sys/class/drm/card1/device
HWMON=/sys/class/hwmon/hwmon1

busy=$(cat "$GPU/gpu_busy_percent" 2>/dev/null || echo 0)
vram_used=$(cat "$GPU/mem_info_vram_used" 2>/dev/null || echo 0)
vram_total=$(cat "$GPU/mem_info_vram_total" 2>/dev/null || echo 1)
temp_raw=$(cat "$HWMON/temp1_input" 2>/dev/null || echo 0)

vram_gb=$(awk "BEGIN {printf \"%.1f\", $vram_used/1073741824}")
vram_total_gb=$(awk "BEGIN {printf \"%.0f\", $vram_total/1073741824}")
temp=$(( temp_raw / 1000 ))

printf '{"text":"󰢮 %s%% %sG","tooltip":"GPU: %s%%\\nVRAM: %sG / %sG\\nTemp: %s°C"}\n' \
    "$busy" "$vram_gb" "$busy" "$vram_gb" "$vram_total_gb" "$temp"
