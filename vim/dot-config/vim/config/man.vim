" Man pages in vim (MANPAGER='vim +MANPAGER --not-a-term -' in zshrc)

" Define :Man and use it for K everywhere
runtime! ftplugin/man.vim
set keywordprg=:Man

augroup ManPages
  autocmd!
  " K follows the reference under the cursor (overrides coc's global K),
  " <BS> goes back, q quits
  autocmd FileType man nnoremap <buffer> <silent> K :call dist#man#PreGetPage(v:count)<CR>
  autocmd FileType man nnoremap <buffer> <silent> <BS> :call dist#man#PopPage()<CR>
  autocmd FileType man nnoremap <buffer> <silent> q :q<CR>

  " Match the LESS_TERMCAP colors: bold -> bold red (base16 08), underline -> bold underlined green (0B)
  autocmd Syntax man call s:ManColors()
augroup END

function! s:ManColors() abort
  let l:red = '#' . get(g:, 'tinted_gui08', 'cc0000')
  let l:green = '#' . get(g:, 'tinted_gui0B', '00cc00')

  for l:group in ['manHeader', 'manSectionHeading', 'manSubHeading', 'manOptionDesc', 'manLongOptionDesc']
    execute 'hi' l:group 'cterm=bold ctermfg=1 gui=bold guifg=' . l:red
  endfor
  execute 'hi manReference cterm=bold,underline ctermfg=2 gui=bold,underline guifg=' . l:green
endfunction
