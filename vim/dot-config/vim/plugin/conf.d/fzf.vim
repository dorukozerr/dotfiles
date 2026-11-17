vim9script

if exists('$TMUX')
  g:fzf_layout = { tmux: '-p100%,100%' }
else
  g:fzf_layout = { window: { width: 1, height: 1 } }
endif
