set rtp+=/opt/homebrew/opt/fzf

if exists('$TMUX')
  let g:fzf_layout = { 'tmux': '100%,100%' }
else
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
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

command! -bang GitStage
      \ call fzf#run(fzf#wrap({
      \   'source': '{ git diff --name-only; git ls-files --others --exclude-standard; } | sort -u',
      \   'options': [
      \     '--multi',
      \     '--preview', 'git diff --color=always -- {} 2>/dev/null || bat --color=always {}',
      \     '--bind', 'ctrl-a:select-all',
      \     '--header', 'TAB: select | CTRL-A: all | ENTER: stage'
      \   ],
      \   'sink*': function('GitPartialAdd')
      \ }, <bang>0))
