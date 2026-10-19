# zmodload zsh/zprof
# # or
# zmodload zsh/datetime; typeset -F _zt=$EPOCHREALTIME

typeset -U path fpath manpath

eval "$(/opt/homebrew/bin/brew shellenv zsh)"

path=(
  $HOMEBREW_PREFIX/opt/man-db/libexec/bin
  $HOMEBREW_PREFIX/opt/ffmpeg-full/bin
  $CARGO_HOME/bin
  $HOME/.local/bin
  $path
)

manpath=(
  $HOMEBREW_PREFIX/share/man
  $XDG_DATA_HOME/vite-plus/js_runtime/node/*/lib/node_modules/*/man(N/)
  ''
)
export MANPATH

export BAT_THEME=ansi
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/ffmpeg-full/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/ffmpeg-full/include"
export MANPAGER="vim +MANPAGER --not-a-term -"

fpath=(
  $RUSTUP_HOME/toolchains/stable-aarch64-apple-darwin/share/zsh/site-functions(N/)
  $XDG_DATA_HOME/zsh-comp(N/)
  $fpath
)

[[ -f "$HOME/.work/.work.zsh" ]] && source "$HOME/.work/.work.zsh"
[[ -f "$HOME/.private/.private.zsh" ]] && source "$HOME/.private/.private.zsh"

zmodload zsh/complist
autoload -Uz compinit
# -C trusts the dump without checking, drop it once a day so new completions get picked up
() { (( $# )) && rm -f $1; compinit -C } $ZDOTDIR/.zcompdump(N.mh+24)
_comp_options+=(globdots)
zstyle ':completion:*' file-list all
# file-list lines aren't colored by type, match them instead: dirs blue, executables red
zstyle ':completion:*' list-colors '=(#b)d* ([^ ]##)=0=34' '=(#b)-??x* ([^ ]##)=0=31'

. "$XDG_CONFIG_HOME/vite-plus/env"

HISTFILE=$XDG_STATE_HOME/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

alias ls="ls -GFlah"

autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{8}%b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{8}%b|%a%u%c%f'

add-zsh-hook precmd vcs_info

setopt PROMPT_SUBST

PROMPT='%F{green}%2~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})%#%f %F{green}%(1j.[%j] .)%f'

export FZF_DEFAULT_OPTS="
  ${FZF_LAYOUT}
  --style=minimal
  --layout=default
  --prompt='󰡭  '
  --pointer=' '
  --marker=' '
  --color='16,bg:#000000,bg+:#000000,border:#000000'
"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview "bat --style=plain --color=always {}" --preview-window=right,60%,border-left'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow'

zvm_after_init_commands+=(
  'source "$ZDOTDIR/plugins/fzf-clipboard/fzf-clipboard.plugin.zsh"'
  'source <(fzf --zsh)'
)

source "$ZDOTDIR/plugins/zsh-autopair/autopair.zsh"
source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

# https://apple.stackexchange.com/questions/48502/how-can-i-permanently-add-my-ssh-private-key-to-keychain-so-it-is-automatically
ssh-add --apple-load-keychain -q

# zprof
# # or
# printf 'startup: %.1fms\n' $(( (EPOCHREALTIME - _zt) * 1000 ))
