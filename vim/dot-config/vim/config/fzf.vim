set runtimepath+=/opt/homebrew/opt/fzf

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p100%,100%' }
else
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
endif
