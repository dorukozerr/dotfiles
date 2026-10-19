#!/bin/bash
# i3 default workspace colors: focused vs inactive
if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=0xff285577 \
                           background.border_color=0xff4c7899 \
                           label.color=0xffffffff
else
  sketchybar --set "$NAME" background.color=0xff222222 \
                           background.border_color=0xff333333 \
                           label.color=0xff888888
fi
