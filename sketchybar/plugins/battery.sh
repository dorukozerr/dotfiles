#!/bin/bash
# i3status battery: "BAT 87% 02:13" / "CHR 87%" / "FULL 100%"
INFO_LINE=$(pmset -g batt | grep -E '[0-9]+%')

if [ -z "$INFO_LINE" ]; then
  sketchybar --set "$NAME" drawing=off   # desktop Mac, no battery
  exit 0
fi

PCT=$(echo "$INFO_LINE" | grep -Eo '[0-9]+%' | tr -d '%')
REMAIN=$(echo "$INFO_LINE" | grep -Eo '[0-9]+:[0-9]+' | head -1)

if echo "$INFO_LINE" | grep -q 'charged'; then
  STATUS="FULL"
elif echo "$INFO_LINE" | grep -qE 'charging|AC attached|finishing charge'; then
  STATUS="CHR"
else
  STATUS="BAT"
fi

# i3status colors: good #00FF00, degraded #FFFF00, bad #FF0000
if [ "$STATUS" = "BAT" ] && [ "$PCT" -le 10 ]; then
  COLOR=0xffff0000
elif [ "$STATUS" = "BAT" ] && [ "$PCT" -le 25 ]; then
  COLOR=0xffffff00
else
  COLOR=0xffffffff
fi

LABEL="$STATUS ${PCT}%"
[ "$STATUS" = "BAT" ] && [ -n "$REMAIN" ] && [ "$REMAIN" != "0:00" ] && LABEL="$LABEL $REMAIN"

sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR
