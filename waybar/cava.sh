#!/usr/bin/env bash
BARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
IGNORE="--ignore-player=firefox,chromium,chrome,brave"
CAVA_PID=""

cleanup() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null
    exit 0
}
trap cleanup EXIT TERM INT

start_cava() {
    if [[ -z "$CAVA_PID" ]] || ! kill -0 "$CAVA_PID" 2>/dev/null; then
        cava -p "$HOME/.config/waybar/cava.ini" | while IFS= read -r line; do
            out=""
            IFS=';' read -ra vals <<< "$line"
            for v in "${vals[@]}"; do
                [[ "$v" =~ ^[0-7]$ ]] || continue
                out+="${BARS[$v]}"
            done
            [[ -n "$out" ]] && printf '{"text":"%s"}\n' "$out"
        done &
        CAVA_PID=$!
    fi
}

stop_cava() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null && CAVA_PID=""
    printf '{"text":"","class":"hidden"}\n'
}

while true; do
    current=$(playerctl $IGNORE status 2>/dev/null)
    if [[ "$current" =~ ^(Playing|Paused)$ ]]; then
        start_cava
    else
        stop_cava
    fi

    while IFS= read -r status; do
        if [[ "$status" =~ ^(Playing|Paused)$ ]]; then
            start_cava
        else
            stop_cava
        fi
    done < <(playerctl $IGNORE --follow status 2>/dev/null)

    stop_cava
    sleep 1
done
