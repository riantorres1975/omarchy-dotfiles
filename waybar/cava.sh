#!/usr/bin/env bash
BARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
IGNORE="--ignore-player=firefox,chromium,chrome,brave"
CAVA_CONFIG="$HOME/.config/waybar/cava.ini"
CAVA_PIPE="/tmp/cava_waybar_pipe_$$"
CAVA_PID=""

cleanup() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null
    rm -f "$CAVA_PIPE"
    exit 0
}
trap cleanup EXIT TERM INT

pkill -f "cava -p $CAVA_CONFIG" 2>/dev/null || true

is_active() {
    playerctl $IGNORE status 2>/dev/null | grep -qE '^(Playing|Paused)$'
}

start_cava() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null
    CAVA_PID=""
    cava -p "$CAVA_CONFIG" | while IFS= read -r line; do
        out=""
        IFS=';' read -ra vals <<< "$line"
        for v in "${vals[@]}"; do
            [[ "$v" =~ ^[0-7]$ ]] || continue
            out+="${BARS[$v]}"
        done
        [[ -n "$out" ]] && printf '{"text":"%s"}\n' "$out"
    done &
    CAVA_PID=$!
}

stop_cava() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null
    CAVA_PID=""
    pkill -f "cava -p $CAVA_CONFIG" 2>/dev/null || true
    printf '{"text":"","class":"hidden"}\n'
}

LAST_STATE=""

update_state() {
    local state
    if is_active; then
        state="active"
    else
        state="inactive"
    fi

    if [[ "$state" != "$LAST_STATE" ]]; then
        LAST_STATE="$state"
        if [[ "$state" == "active" ]]; then
            start_cava
        else
            stop_cava
        fi
    fi
}

# Estado inicial
update_state

# Monitorear con playerctl --follow; si falla, relanzar con polling
while true; do
    while IFS= read -r _status; do
        update_state
    done < <(playerctl $IGNORE --follow status 2>/dev/null)

    # playerctl salió (sin reproductores o nuevo jugador): re-evaluar
    update_state
    sleep 2
done
