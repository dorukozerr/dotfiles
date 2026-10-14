#!/bin/bash
# Keep-awake indicator. The toggle itself lives in bin/caffeinate_toggle.
if [ "$SENDER" = "mouse.clicked" ]; then
  exec "$(dirname "$0")/../bin/caffeinate_toggle"
fi

if pgrep -fx "caffeinate -dimsu" >/dev/null; then
  sketchybar --set "$NAME" icon=󰅶 icon.color=0xffffffff
else
  sketchybar --set "$NAME" icon=󰛊 icon.color=0xff555555
fi
