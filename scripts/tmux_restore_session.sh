#!/bin/bash

SAVE_FILE="$HOME/.config/tmux/session"

if [ ! -f "$SAVE_FILE" ]; then
    exit 1
fi

sessions_created=""
windows_created=""

while IFS='|' read -r type session window_index window_name pane_index pane_path; do
    if [ "$type" = "PANE" ]; then
        window_key="${session}:${window_index}"
        if ! echo "$sessions_created" | grep -qx "$session"; then
            tmux new-session -d -s "$session" -c "$HOME"
            sessions_created="${sessions_created}${session}"$'\n'
            windows_created="${windows_created}${session}:0"$'\n'
            tmux send-keys -t "$session:0.0" "cd '$pane_path'" C-m
            tmux send-keys -t "$session:0.0" "clear" C-m
            if [ "$window_index" != "0" ]; then
                tmux new-window -t "$session:$window_index" -n "$window_name" -c "$HOME"
                windows_created="${windows_created}${window_key}"$'\n'
                tmux send-keys -t "$session:$window_index.0" "cd '$pane_path'" C-m
                tmux send-keys -t "$session:$window_index.0" "clear" C-m
            fi
            continue
        fi
        if ! echo "$windows_created" | grep -qx "$window_key"; then
            tmux new-window -t "$session:$window_index" -n "$window_name" -c "$HOME"
            windows_created="${windows_created}${window_key}"$'\n'
            tmux send-keys -t "$session:$window_index.0" "cd '$pane_path'" C-m
            tmux send-keys -t "$session:$window_index.0" "clear" C-m
        else
            tmux split-window -t "$session:$window_index" -c "$pane_path"
        fi
    elif [ "$type" = "LAYOUT" ]; then
        tmux select-layout -t "$session:$window_index" "$window_name" 2>/dev/null
    fi
done < "$SAVE_FILE"
