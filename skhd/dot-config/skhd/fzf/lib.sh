# lib.sh — sourced by the fzf pickers in this folder.
#
#   fzf_ensure_terminal "$0" "$@"
#
# From a terminal it just returns and the picker carries on: fzf-tmux opens a
# popup inside tmux and falls back to plain fzf outside of it.
#
# From skhd (no tty) it re-runs the picker somewhere visible and exits:
#
#   1. a tmux client is attached -> 100% popup over it, like the M-Y binding
#   2. wezterm is open           -> new window in that same wezterm process
#   3. nothing is open           -> launch wezterm with the picker in it
#
# and once the picker is done, focus goes back to the app that was in front.
#
# Written for macOS' bash 3.2.

# skhd's PATH comes from its launchd plist; don't rely on it.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

WEZTERM_BUNDLE=com.github.wez.wezterm

front_app() {
  lsappinfo info -only bundleid "$(lsappinfo front)" \
    | sed -n 's/.*bundle[Ii][Dd]"*="\([^"]*\)".*/\1/p' \
    | head -n1
}

return_focus() {
  [ -n "$FZF_RETURN_APP" ] && [ "$FZF_RETURN_APP" != "$WEZTERM_BUNDLE" ] \
    && open -b "$FZF_RETURN_APP"
  return 0
}

# tmux client the user touched last, empty when none is attached.
tmux_client() {
  tmux list-clients -F '#{client_activity} #{client_name}' 2>/dev/null \
    | sort -rn | head -n1 | cut -d' ' -f2
}

fzf_ensure_terminal() {
  if [ -t 0 ]; then
    # Started by one of the branches below: hand focus back however we exit.
    [ -n "$FZF_RETURN_APP" ] && trap return_focus EXIT
    # New wezterm window: hold until wezterm has filled it (helpers.lua answers
    # the wez_wait_tile user var with a newline) so fzf starts at full size.
    if [ -n "$FZF_WAIT_TILE" ]; then
      unset FZF_WAIT_TILE
      printf '\033]1337;SetUserVar=wez_wait_tile=%s\007' "$(printf 1 | base64)"
      stty -echo
      read -r -t 2 _
      stty echo
    fi
    return 0
  fi

  front=$(front_app)
  client=$(tmux_client)

  if [ -n "$client" ]; then
    pane=$(tmux display-message -p -c "$client" '#{pane_id}')
    # The popup already is the full-screen picker, so drop TMUX inside it and
    # let fzf-tmux fall back to plain fzf instead of nesting another popup.
    cmd=$(printf '%q ' env -u TMUX "FZF_RETURN_APP=$front" "TMUX_PANE=$pane" "$@")
    open -b "$WEZTERM_BUNDLE"
    tmux display-popup -c "$client" -E -w 100% -h 100% -b none "$cmd" >/dev/null 2>&1 &
  elif pid=$(pgrep -x wezterm-gui | head -n1) && [ -n "$pid" ]; then
    # Talk to the live GUI directly; ~/.local/share/wezterm is full of stale
    # gui-sock-* files and auto-discovery can pick a dead one.
    WEZTERM_UNIX_SOCKET="$HOME/.local/share/wezterm/gui-sock-$pid" \
      wezterm cli --no-auto-start spawn --new-window --cwd "$HOME" -- \
      env "FZF_RETURN_APP=$front" FZF_WAIT_TILE=1 "$@" >/dev/null
    open -b "$WEZTERM_BUNDLE"
  else
    open -b "$WEZTERM_BUNDLE" --args start --cwd "$HOME" -- \
      env "FZF_RETURN_APP=$front" FZF_WAIT_TILE=1 "$@"
  fi

  exit 0
}
