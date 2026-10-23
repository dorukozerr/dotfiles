# zmodload zsh/zprof
# # or
# zmodload zsh/datetime; typeset -F _zt=$EPOCHREALTIME

typeset -U path fpath

eval "$(/opt/homebrew/bin/brew shellenv zsh)"

path=(
  $HOMEBREW_PREFIX/opt/ffmpeg-full/bin
  $CARGO_HOME/bin
  $HOME/.local/bin
  $path
)

export BAT_THEME="base16-256"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/ffmpeg-full/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/ffmpeg-full/include"
export TCP_LOG="$HOME/.local/state/tcp/session.log"
export MANPAGER='vim +MANPAGER --not-a-term -'

fpath=(
  $RUSTUP_HOME/toolchains/stable-aarch64-apple-darwin/share/zsh/site-functions(N/)
  $XDG_DATA_HOME/zsh-comp(N/)
  $fpath
)

zmodload zsh/complist

zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' completions '#'
zstyle ':completion:*' format '%d'
zstyle ':completion:*' glob '!'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[]=** r:|=**'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' substitute '$'
zstyle ':completion:*' verbose true
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' file-list all
zstyle ':completion:*' list-colors '=(#b)d* ([^ ]##)=0=34' '=(#b)-??x* ([^ ]##)=0=31'

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

source "$XDG_CONFIG_HOME/vite-plus/env"

autoload -Uz vcs_info add-zsh-hook 
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%u%c%m%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b|%a%u%c%m%f'
zstyle ':vcs_info:git:*' branchformat '%F{yellow}%b:%r%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-aheadbehind

# ↑N commits to push, ↓N commits to pull (compared to the upstream branch)
+vi-git-aheadbehind() {
  local ahead behind
  read -r ahead behind < <(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null) || return
  (( ahead )) && hook_com[misc]+=" ↑$ahead"
  (( behind )) && hook_com[misc]+=" ↓$behind"
}

add-zsh-hook precmd vcs_info
setopt PROMPT_SUBST
PROMPT='%F{green}%2~%f${vcs_info_msg_0_} %F{green}%(1j.[%j] .)%(?..%F{red})%#%f '

HISTFILE=$XDG_STATE_HOME/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS 

setopt INTERACTIVE_COMMENTS

autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

alias ls="ls -GFlah"

export FZF_DEFAULT_OPTS="
  --style=minimal
  --reverse
  --border=none
  --list-border=none
  --input-border=none
  --preview-border=none
  --prompt='% '
  --pointer='> '
  --marker='! '
  --color=base16
"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
source <(fzf --zsh)

source "$ZDOTDIR/plugins/zsh-autopair/autopair.zsh"
source "$ZDOTDIR/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$ZDOTDIR/plugins/fzf-clipboard/fzf-clipboard.plugin.zsh"

typeset -ga ZVM_DISABLED_KEYS=("viins ^R" "viins ^T" "viins ^Y")
functions[_zvm_bindkey_orig]=$functions[zvm_bindkey]
zvm_bindkey() {
  (( ${ZVM_DISABLED_KEYS[(Ie)$1 $2]} )) && return
  _zvm_bindkey_orig "$@"
}

# https://apple.stackexchange.com/questions/48502/how-can-i-permanently-add-my-ssh-private-key-to-keychain-so-it-is-automatically
ssh-add --apple-load-keychain -q

# zprof
# # or
# printf 'startup: %.1fms\n' $(( (EPOCHREALTIME - _zt) * 1000 ))

# The following lines were added by compinstall

# End of lines added by compinstall
