set rtp+=/opt/homebrew/opt/fzf

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '70%,85%' }
else
  let g:fzf_layout = { 'window': { 'width': 0.7, 'height': 0.85 } }
endif

let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right:50%:wrap', 'ctrl-/']

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>,
      \   fzf#vim#with_preview({
      \     'source': 'rg --files --hidden --follow --glob "!.git/*"'
      \   }), <bang>0)

command! -bang -nargs=* RG
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case --fixed-strings '.
      \   '-- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(),
      \   <bang>0)

command! -bang -range=% -nargs=* Commits
      \ let b:fzf_winview = winsaveview() |
      \ <line1>,<line2>call fzf#vim#commits(<q-args>,
      \   extend(fzf#vim#with_preview({ "placeholder": "" }), {
      \     'options': get(fzf#vim#with_preview({ "placeholder": "" }), 'options', [])
      \   }), <bang>0)
