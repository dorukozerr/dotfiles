" " I wish I could understand and write something like this myself...
" " Original author https://github.com/arp242/startscreen.vim
" 
" scriptencoding utf-8
" 
" if exists('g:loaded_startscreen') | finish | endif
" 
" let g:loaded_startscreen = 1
" let s:save_cpo = &cpo
" 
" set cpo&vim
" 
" fun! startscreen#fortune()
" 	let l:fortune = systemlist('fortune')
" 
" 	call append('0', ['', ''] + map(l:fortune, '"        " . v:val'))
" 
" 	:1
" 
" 	redraw!
" 
" 	nnoremap <buffer> <silent> <Return> :enew<CR>:call startscreen#start()<CR>
" endfun
" 
" if !exists('g:Startscreen_function')
" 	let g:Startscreen_function = function('startscreen#fortune')
" endif
" 
" fun! startscreen#start()
" 	if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
" 		return
" 	endif
" 
" 	enew
" 
" 	setlocal
" 				\ bufhidden=wipe
" 				\ buftype=nofile
" 				\ nobuflisted
" 				\ nocursorcolumn
" 				\ nocursorline
" 				\ nolist
" 				\ nonumber
" 				\ noswapfile
" 				\ norelativenumber
" 
" 	call g:Startscreen_function()
" 
" 	setlocal nomodifiable nomodified
" 
" 	nnoremap <buffer><silent> e :enew<CR>
" 	nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
" 	nnoremap <buffer><silent> o :enew <bar> startinsert<CR><CR>
" 	nnoremap <buffer><silent> p :enew<CR>p
" 	nnoremap <buffer><silent> P :enew<CR>P
" endfun
" 
" augroup startscreen
" 	autocmd!
" 	autocmd VimEnter * call startscreen#start()
" augroup end
" 
" let &cpo = s:save_cpo
" 
" unlet s:save_cpo

scriptencoding utf-8

if exists('g:loaded_startscreen') | finish | endif

let g:loaded_startscreen = 1
let s:save_cpo = &cpo

set cpo&vim

let s:ascii_art = [
      \ '  ▄████  ██▓▄▄▄█████▓     ▄████  █    ██ ▓█████▄ ',
      \ ' ██▒ ▀█▒▓██▒▓  ██▒ ▓▒    ██▒ ▀█▒ ██  ▓██▒▒██▀ ██▌',
      \ '▒██░▄▄▄░▒██▒▒ ▓██░ ▒░   ▒██░▄▄▄░▓██  ▒██░░██   █▌',
      \ '░▓█  ██▓░██░░ ▓██▓ ░    ░▓█  ██▓▓▓█  ░██░░▓█▄   ▌',
      \ '░▒▓███▀▒░██░  ▒██▒ ░    ░▒▓███▀▒▒▒█████▓ ░▒████▓ ',
      \ ' ░▒   ▒ ░▓    ▒ ░░       ░▒   ▒ ░▒▓▒ ▒ ▒  ▒▒▓  ▒ ',
      \ '  ░   ░  ▒ ░    ░         ░   ░ ░░▒░ ░ ░  ░ ▒  ▒ ',
      \ '░ ░   ░  ▒ ░  ░         ░ ░   ░  ░░░ ░ ░  ░ ░  ░ ',
      \ '      ░  ░                    ░    ░        ░    ',
      \ '                                          ░      ',
      \ ]

let s:humiliation_messages = [
      \ "Another day of pretending you know what you're doing?",
      \ "Even rubber duck debugging gave up on you.",
      \ "Your code has more bugs than features, impressive really.",
      \ "Your function names are as meaningful as your life choices.",
      \ "Your variable names suggest you've given up on communication.",
      \ "Your git history looks like a toddler's art project.",
      \ ]

fun! startscreen#center_text(text, width)
  let l:padding = (a:width - strwidth(a:text)) / 2

  return repeat(' ', l:padding) . a:text
endfun

fun! startscreen#custom_art()
  let l:win_width = winwidth(0)
  let l:win_height = winheight(0)

  let l:was_modifiable = &l:modifiable
  setlocal modifiable

  %delete _

  let l:art_height = len(s:ascii_art)
  let l:total_content_height = l:art_height + 4
  let l:top_padding = max([0, (l:win_height - l:total_content_height) / 2])

  call append(0, repeat([''], l:top_padding))

  let l:art_start = line('$') + 1

  for line in s:ascii_art
    call append(line('$'), startscreen#center_text(line, l:win_width))
  endfor

  let l:art_end = line('$')

  call append(line('$'), ['', ''])
  let l:message_index = localtime() % len(s:humiliation_messages)
  let l:message = s:humiliation_messages[l:message_index]
  let l:message_line = line('$') + 1

  call append(line('$'), startscreen#center_text(l:message, l:win_width))
  call append(line('$'), '')

  :1

  if !l:was_modifiable
    setlocal nomodifiable
  endif

  redraw!

  nnoremap <buffer> <silent> <Return> :enew<CR>:call startscreen#start()<CR>
  nnoremap <buffer> <silent> r :call startscreen#refresh()<CR>
endfun

fun! startscreen#refresh()
  call startscreen#custom_art()
endfun

if !exists('g:Startscreen_function')
  let g:Startscreen_function = function('startscreen#custom_art')
endif

fun! startscreen#start()
  if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
    return
  endif

  enew

  setlocal
        \ bufhidden=wipe
        \ buftype=nofile
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ noswapfile
        \ norelativenumber

  call g:Startscreen_function()

  setlocal nomodifiable nomodified

  nnoremap <buffer><silent> e :enew<CR>
  nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
  nnoremap <buffer><silent> o :enew <bar> startinsert<CR><CR>
  nnoremap <buffer><silent> p :enew<CR>p
  nnoremap <buffer><silent> P :enew<CR>P
  nnoremap <buffer><silent> r :call startscreen#refresh()<CR>
endfun

augroup startscreen
  autocmd!
  autocmd VimEnter * call startscreen#start()
  autocmd VimResized * if &buftype ==# 'nofile' | call startscreen#custom_art() | endif
  autocmd WinEnter * if &buftype ==# 'nofile' && expand('%') == '' | call startscreen#custom_art() | endif
augroup end

let &cpo = s:save_cpo

unlet s:save_cpo

