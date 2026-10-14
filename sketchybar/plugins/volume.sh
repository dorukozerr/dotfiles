#!/bin/bash
# On volume_change, sketchybar passes the new volume in $INFO
if [ "$SENDER" = "volume_change" ]; then
  VOL="$INFO"
else
  VOL=$(osascript -e 'output volume of (get volume settings)')
fi

MUTED=$(osascript -e 'output muted of (get volume settings)')

if [ "$MUTED" = "true" ] || [ "$VOL" = "0" ]; then
  sketchybar --set "$NAME" label="♪: muted" label.color=0xffffff00
else
  sketchybar --set "$NAME" label="♪: ${VOL}%" label.color=0xffffffff
fi
