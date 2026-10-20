#!/usr/bin/env bash

# fzf picker for the wezterm background, opened from the command palette.
#
#   background.sh <dir> <current file>
#
# the window behind previews each image as it's focused, enter keeps it and
# esc restores <current file>. the choice is sent back to wezterm as the
# `wez_bg` user var (OSC 1337 SetUserVar), handled in helpers.lua

# wezterm started from the Dock only gets the system PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# inside tmux the sequence has to be wrapped to pass through to wezterm
# (needs `set -g allow-passthrough on`)
set_bg() {
  local seq
  seq=$(printf '\033]1337;SetUserVar=wez_bg=%s\007' "$(printf %s "$1" | base64)")
  if [ -n "$TMUX" ]; then
    seq=$(printf '\033Ptmux;\033%s\033\\' "$seq")
  fi
  printf '%s' "$seq" > /dev/tty
}

# the preview pane is chafa character art (symbols mode), low-res by nature
# and fast to redraw since it's plain colored text sized to the pane. chafa
# reads a cached 320px png thumbnail instead of the 4k original so decoding
# stays cheap; thumbnails are rebuilt when the source is newer
thumbs="${XDG_CACHE_HOME:-$HOME/.cache}/wezterm/backgrounds"

preview() {
  local thumb="$thumbs/$(basename "$1")"
  if [ ! -f "$thumb" ] || [ "$1" -nt "$thumb" ]; then
    mkdir -p "$thumbs"
    sips -Z 320 "$1" --out "$thumb" > /dev/null
  fi
  chafa -f symbols -c full --animate off \
    -s "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$thumb"
}

case $1 in
  set) set_bg "$2"; exit 0 ;;
  preview) preview "$2"; exit 0 ;;
esac

dir=$1
current=$2

pick=$(rg --files --max-depth 1 --glob '*.png' --sort path "$dir" | fzf-tmux \
  --color='bg:0' \
  --prompt='background> ' \
  --header='enter: keep   esc: restore' \
  --delimiter=/ \
  --with-nth=-1 \
  --bind="focus:execute-silent('$0' set {})" \
  --layout=reverse-list \
  --preview="'$0' preview {}" \
  --preview-window='right,70%,border-left' \
  -p '100%,100%')

set_bg "${pick:-$current}"
exit 0
