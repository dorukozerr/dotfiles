#!/bin/bash

SAVE_FILE="$HOME/.config/tmux/session"

> "$SAVE_FILE"

tmux list-sessions -F "#{session_name}" 2>/dev/null | while IFS= read -r session; do
    tmux list-windows -t "$session" -F "#{window_index}:#{window_name}" | while IFS= read -r window_info; do
        window_index="${window_info%%:*}"
        window_name="${window_info#*:}"
        tmux list-panes -t "$session:$window_index" -F "#{pane_index}:#{pane_current_path}" | while IFS= read -r pane_info; do
            pane_index="${pane_info%%:*}"
            pane_path="${pane_info#*:}"
            echo "PANE|$session|$window_index|$window_name|$pane_index|$pane_path" >> "$SAVE_FILE"
        done
        layout=$(tmux list-windows -t "$session:$window_index" -F "#{window_layout}" | head -n 1)
        echo "LAYOUT|$session|$window_index|$layout" >> "$SAVE_FILE"
    done
done

