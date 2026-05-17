eval "$(/opt/homebrew/bin/brew shellenv)"

export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# export TERM="wezterm"
export EDITOR="vi"
export BAT_THEME="ansi"
export BUN_INSTALL="$HOME/.bun"

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -s "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh" ] && source "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh"
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.vite-plus/env ] && source ~/.vite-plus/env
