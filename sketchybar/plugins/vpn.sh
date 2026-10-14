#!/bin/bash
# Mullvad status via its CLI. Click the item to connect/disconnect.
# brew services runs sketchybar with a minimal PATH, so look in the usual places.
MULLVAD=$(command -v mullvad || ls /usr/local/bin/mullvad /opt/homebrew/bin/mullvad 2>/dev/null | head -1)

if [ -z "$MULLVAD" ]; then
  sketchybar --set "$NAME" label="VPN: no cli" label.color=0xff888888
  exit 0
fi

if [ "$SENDER" = "mouse.clicked" ]; then
  if "$MULLVAD" status | head -1 | grep -q '^Connected'; then
    "$MULLVAD" disconnect >/dev/null
  else
    "$MULLVAD" connect >/dev/null
  fi
  sleep 1
fi

STATUS=$("$MULLVAD" status 2>/dev/null)
STATE=$(echo "$STATUS" | head -1)

case "$STATE" in
  Connected*)
    # "Visible location: Germany, Frankfurt. IPv4: ..." → "Frankfurt"
    CITY=$(echo "$STATUS" | sed -n 's/.*Visible location: *[^,]*, *\([^.]*\).*/\1/p' | head -1)
    sketchybar --set "$NAME" label="VPN: ${CITY:-on}" label.color=0xff00ff00 ;;
  Connecting*|Disconnecting*)
    sketchybar --set "$NAME" label="VPN: ..." label.color=0xffffff00 ;;
  *)
    sketchybar --set "$NAME" label="VPN: off" label.color=0xffff0000 ;;
esac
