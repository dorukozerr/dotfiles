export FZF_DEFAULT_OPTS="
  ${FZF_LAYOUT}
  --style=minimal
  --color=base16
  --layout=default
  --prompt='󰡭  '
  --pointer=' '
  --marker=' '
"

export FZF_CTRL_T_OPTS='--preview "bat --style=plain --color=always {}" --preview-window=right,60%,border-left'
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob "!.git/*""
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"

source <(fzf --zsh)
