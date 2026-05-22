#!/usr/bin/env bash

DATA=$(curl -sf --max-time 5 "https://wttr.in/?format=j1" 2>/dev/null)
if [[ -z "$DATA" ]]; then
    printf '{"text":"󰖙 --","tooltip":"Sin conexión"}'
    exit 0
fi

TMPJSON=$(mktemp --suffix=.json)
printf '%s' "$DATA" > "$TMPJSON"

python3 - "$TMPJSON" <<'PYEOF'
import json, sys
from datetime import datetime

with open(sys.argv[1], encoding='utf-8') as f:
    data = json.load(f)

current  = data['current_condition'][0]
code     = int(current['weatherCode'])
temp     = current['temp_C']
feels    = current['FeelsLikeC']
desc     = current['weatherDesc'][0]['value']
humidity = current['humidity']
wind     = current['windspeedKmph']

def fix_enc(s):
    try:
        return s.encode('latin-1').decode('utf-8')
    except (UnicodeEncodeError, UnicodeDecodeError):
        return s

area     = data['nearest_area'][0]
city     = fix_enc(area['areaName'][0]['value'])
region   = fix_enc(area['region'][0]['value'])
country  = fix_enc(area['country'][0]['value'])
location = f"{city}, {region}, {country}"

astronomy = data['weather'][0]['astronomy'][0]
sunrise   = astronomy['sunrise']
sunset    = astronomy['sunset']

def parse_ampm(t):
    now = datetime.now()
    return datetime.strptime(t, "%I:%M %p").replace(
        year=now.year, month=now.month, day=now.day)

now    = datetime.now().replace(second=0, microsecond=0)
is_day = parse_ampm(sunrise) <= now <= parse_ampm(sunset)

def icon(code, day):
    if code == 113:                                     return "󰖨" if day else "󰖔"
    if code == 116:                                     return "󰖕" if day else "󰖕"
    if code in (119, 122):                              return "󰖐"
    if code in (143, 248, 260):                         return "󰖑"
    if code in (200, 386, 389, 392, 395):               return "󰖓"
    if code in (227, 230, 323, 326, 329, 332, 335,
                338, 350, 362, 365, 368, 371, 374):     return "󰖘"
    return "󰖗"

ico  = icon(code, is_day)
text = f"{ico} {temp}°C"
tip  = (f"{location}\n"
        f"{desc}\n"
        f"Temp {temp}°C  (sensacion {feels}°C)  Hum {humidity}%  Viento {wind} km/h\n"
        f"Amanecer {sunrise}  Atardecer {sunset}")

print(json.dumps({"text": text, "tooltip": tip}))
PYEOF

rm -f "$TMPJSON"
