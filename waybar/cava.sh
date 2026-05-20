#!/usr/bin/env bash
BARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")
IGNORE="--ignore-player=firefox,chromium,chrome,brave"
CAVA_PID=""

cleanup() {
    [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null
    exit 0
}
trap cleanup EXIT TERM INT

while true; do
    # Espera hasta que haya un player activo
    if ! playerctl $IGNORE status &>/dev/null; then
        [[ -n "$CAVA_PID" ]] && kill "$CAVA_PID" 2>/dev/null && CAVA_PID=""
        echo ""
        sleep 2
        continue
    fi

    # Lanza cava si no está corriendo
    if [[ -z "$CAVA_PID" ]] || ! kill -0 "$CAVA_PID" 2>/dev/null; then
        cava -p "$HOME/.config/waybar/cava.ini" | while IFS= read -r line; do
            out=""
            IFS=';' read -ra vals <<< "$line"
            for v in "${vals[@]}"; do
                [[ "$v" =~ ^[0-7]$ ]] || continue
                out+="${BARS[$v]}"
            done
            [[ -n "$out" ]] && printf '%s\n' "$out"
        done &
        CAVA_PID=$!
    fi

    sleep 2
done
