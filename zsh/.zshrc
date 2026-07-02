# zmodload zsh/zprof

source "$ZDOTDIR/zsh.d/history.zsh"
source "$ZDOTDIR/zsh.d/aliases.zsh"
source "$ZDOTDIR/zsh.d/compinit.zsh"
source "$ZDOTDIR/zsh.d/plugins.zsh"
source "$ZDOTDIR/zsh.d/vi.zsh"
source "$ZDOTDIR/zsh.d/fzf.zsh"
source "$ZDOTDIR/zsh.d/env.zsh"
source "$ZDOTDIR/zsh.d/prompt.zsh"

[ -f ~/.private/.private.zsh ] && source ~/.private/.private.zsh

# zprof

# pnpm
export PNPM_HOME="/Users/suqoi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
