vim9script

# Man pages in vim (MANPAGER='vim +MANPAGER --not-a-term -' in zshrc)
#
#  Define :Man and use it for K everywhere

setlocal keywordprg=:Man

aug ManPages
  au!
  au FileType man nnoremap <buffer> <silent> <unique> K call dist#man#PreGetPage(v:count)<CR>
  au FileType man nnoremap <buffer> <silent> <unique> <BS> call dist#man#PopPage()<CR>
  au FileType man nnoremap <buffer> <silent> <unique> :q q<CR>
  au Syntax man call ManColors()
aug END

def ManColors()
  var red = '#' .. get(g:, 'tinted_gui08', 'cc0000')
  var green = '#' .. get(g:, 'tinted_gui0B', '00cc00')

  for group in ['manHeader', 'manSectionHeading', 'manSubHeading', 'manOptionDesc', 'manLongOptionDesc']
    execute 'hi' group 'cterm=bold ctermfg=1 gui=bold guifg=' .. red
  endfor

  exe 'hi manReference cterm=bold,underline ctermfg=2 gui=bold,underline guifg=' .. green
enddef
