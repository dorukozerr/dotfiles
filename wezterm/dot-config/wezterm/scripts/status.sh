#!/usr/bin/env bash

# Stats for the wezterm status bar, one line per item:
#   tmux <sessions> <windows> <panes>
#   net <rx bytes> <tx bytes>
#
# network sums the physical en* interfaces: with a VPN up its encrypted traffic
# still flows through them, so the numbers are right with the VPN on or off

# wezterm started from the Dock only gets the system PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/sbin:$PATH"

tmux list-panes -a -F '#{session_name}|#{window_id}' 2>/dev/null |
  awk -F'|' '{s[$1]; w[$2]; p++} END {n = 0; for (k in s) n++; m = 0; for (k in w) m++; print "tmux", n, m, p + 0}'

netstat -ibn | awk '$1 ~ /^en[0-9]+$/ && $3 ~ /^<Link#/ {i += $7; o += $10} END {print "net", i + 0, o + 0}'
