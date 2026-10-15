# zmodload zsh/zprof
# # or
# zmodload zsh/datetime; typeset -F _zt=$EPOCHREALTIME

typeset -U path fpath

eval "$(/opt/homebrew/bin/brew shellenv zsh)"

export BAT_THEME=ansi
export BUN_INSTALL=$HOME/.bun
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/ffmpeg-full/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/ffmpeg-full/include"

path=(
  $HOME/.cargo/bin
  $HOMEBREW_PREFIX/opt/ffmpeg-full/bin
  $BUN_INSTALL/bin
  $HOME/.local/bin
  $HOME/bin
  ${ASDF_DATA_DIR:-$HOME/.asdf}/shims
  $path
)

[[ -f ~/.vite-plus/env ]] && source ~/.vite-plus/env
[[ -f ~/.work/.work.zsh ]] && source ~/.work/.work.zsh
[[ -f ~/.private/.private.zsh ]] && source ~/.private/.private.zsh

fpath=(
  $HOME/.docker/completions(N/)
  $HOME/.rustup/toolchains/stable-aarch64-apple-darwin/share/zsh/site-functions(N/)
  $BUN_INSTALL(N/)
  $HOME/.local/share/zsh-comp(N/)
  $fpath
)

autoload -Uz compinit
() {
  setopt local_options extended_glob
  local dump=$ZDOTDIR/.zcompdump
  if [[ -n $dump(#qN.mh+24) ]]; then compinit -d $dump; else compinit -C -d $dump; fi
  [[ $dump.zwc -nt $dump ]] || zcompile -R -- $dump.zwc $dump &!
}

HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

alias ls="ls -GFlah --color"
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{8}%b%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{8}%b|%a%u%c%f'
add-zsh-hook precmd vcs_info
setopt PROMPT_SUBST
PROMPT='%F{green}%2~%f${vcs_info_msg_0_} %F{green}%(1j.[%j] .)%(?..%F{red})%#%f '

source $ZDOTDIR/plugins/fzf-clipboard/fzf-clipboard.plugin.zsh
source $ZDOTDIR/plugins/zsh-autopair/autopair.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# keep fzf's ^R/^T and ^Y from being clobbered by zsh-vi-mode's lazy init
typeset -ga ZVM_DISABLED_KEYS=("viins ^R" "viins ^T" "viins ^Y")
functions[_zvm_bindkey_orig]=$functions[zvm_bindkey]
zvm_bindkey() {
  (( ${ZVM_DISABLED_KEYS[(Ie)$1 $2]} )) && return
  _zvm_bindkey_orig "$@"
}

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
source <(fzf --zsh)

# zprof
# # or
# printf 'startup: %.1fms\n' $(( (EPOCHREALTIME - _zt) * 1000 ))
