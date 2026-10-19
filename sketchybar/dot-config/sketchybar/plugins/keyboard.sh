#!/bin/bash
# Current keyboard layout / input source, short like i3's xkb indicator ("US", "TR").
# Click: switch to the next input source (sends Ctrl+Space, the macOS default
# "Select the previous input source" shortcut).

if [ "$SENDER" = "mouse.clicked" ]; then
  osascript -e 'tell application "System Events" to key code 49 using control down'
  sleep 0.2
fi

SOURCES=$(defaults read com.apple.HIToolbox AppleSelectedInputSources 2>/dev/null)

# Keyboard layouts report "KeyboardLayout Name"; input methods (Japanese, Chinese…)
# report "Input Mode" instead.
NAME_RAW=$(echo "$SOURCES" | sed -n 's/.*"KeyboardLayout Name" = "\{0,1\}\([^";]*\)"\{0,1\};.*/\1/p' | head -1)
if [ -z "$NAME_RAW" ]; then
  NAME_RAW=$(echo "$SOURCES" | sed -n 's/.*"Input Mode" = "\{0,1\}\([^";]*\)"\{0,1\};.*/\1/p' | head -1 | awk -F. '{print $NF}')
fi

case "$NAME_RAW" in
  "U.S."|"ABC"|"US")         SHORT="US" ;;
  "Turkish Q"|"Turkish-QWERTY-PC"|"Turkish") SHORT="TR" ;;
  "Turkish F")               SHORT="TR-F" ;;
  "British"|"British-PC")    SHORT="UK" ;;
  "German")                  SHORT="DE" ;;
  "French")                  SHORT="FR" ;;
  "Russian"|"RussianWin")    SHORT="RU" ;;
  "")                        SHORT="??" ;;
  *)                         SHORT="$NAME_RAW" ;;
esac

sketchybar --set "$NAME" label="$SHORT"
