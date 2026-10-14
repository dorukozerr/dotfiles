#!/bin/bash
# Dim HH:MM shown on every display except the focused one (focused gets the full status).
ALL=$(sketchybar --query displays | sed -n 's/.*"arrangement-id":\([0-9]*\).*/\1/p')

if [ "$SENDER" = "display_change" ] && echo "$ALL" | grep -qx "$INFO"; then
  ACTIVE="$INFO"
else
  # "clock" uses display=active, so its only on-screen rect is on the active display
  ACTIVE=$(sketchybar --query clock | awk '
    /"display-[0-9]+"/ { d = $1; gsub(/[^0-9]/, "", d) }
    /"origin"/ && $3 != "-9999.000000," { print d; exit }')
fi

OTHERS=$(echo "$ALL" | grep -vx "${ACTIVE:-0}" | paste -sd, -)

if [ -z "$OTHERS" ]; then
  sketchybar --set "$NAME" drawing=off
else
  sketchybar --set "$NAME" drawing=on display="$OTHERS" label="$(date '+%H:%M')"
fi
