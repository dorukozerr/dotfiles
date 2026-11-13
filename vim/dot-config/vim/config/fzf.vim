set runtimepath+=/opt/homebrew/opt/fzf

""let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob \"!.git/*"'

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '-p100%,100%' }
else
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
endif

let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right:50%:wrap', 'ctrl-/']
