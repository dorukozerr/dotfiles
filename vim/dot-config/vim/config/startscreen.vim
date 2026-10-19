vim9script
scriptencoding utf-8

if exists('g:loaded_startscreen') | finish | endif
g:loaded_startscreen = 1

highlight default link StartScreenArt Statement
highlight default link StartScreenMsg Comment
for t in ['Art', 'Msg']
  if prop_type_get('StartScreen' .. t) == {}
    prop_type_add('StartScreen' .. t, {highlight: 'StartScreen' .. t})
  endif
endfor

const s_chars = split('!<>-_\/[]{}—=+*^?#$%&abcdefghijklmnopqrstuvwxyz01', '\zs')
const s_speed = 1.4   # characters revealed per frame
const s_hold = 110    # frames a finished message lingers before rotating
const s_msgs = [
  "Another day of pretending you know what you're doing?",
  "Even rubber duck debugging gave up on you.",
  "Your code has more bugs than features, impressive really.",
  "Your function names are as meaningful as your life choices.",
  "Your variable names suggest you've given up on communication.",
  "Your git history looks like a toddler's art project.",
  "The compiler warnings are just cries for help at this point.",
  "You've reinvented the wheel, but square this time.",
  "Your tests pass because you don't to write them.",
  "TODO: learn to code. Dated three years ago.",
  "Merge conflicts fear no one, least of all you.",
  "Semicolons weep quietly wherever you go.",
  "You debug by adding print statements and prayer.",
  "Refactoring, or as you call it, breaking what worked.",
]
const s_art = [
  '  ▄████  ██▓▄▄▄█████▓     ▄████  █    ██ ▓█████▄ ',
  ' ██▒ ▀█▒▓██▒▓  ██▒ ▓▒    ██▒ ▀█▒ ██  ▓██▒▒██▀ ██▌',
  '▒██░▄▄▄░▒██▒▒ ▓██░ ▒░   ▒██░▄▄▄░▓██  ▒██░░██   █▌',
  '░▓█  ██▓░██░░ ▓██▓ ░    ░▓█  ██▓▓▓█  ░██░░▓█▄   ▌',
  '░▒▓███▀▒░██░  ▒██▒ ░    ░▒▓███▀▒▒▒█████▓ ░▒████▓ ',
  ' ░▒   ▒ ░▓    ▒ ░░       ░▒   ▒ ░▒▓▒ ▒ ▒  ▒▒▓  ▒ ',
  '  ░   ░  ▒ ░    ░         ░   ░ ░░▒░ ░ ░  ░ ▒  ▒ ',
  '░ ░   ░  ▒ ░  ░         ░ ░   ░  ░░░ ░ ░  ░ ░  ░ ',
  '      ░  ░                    ░    ░        ░    ',
  '                                          ░      ',
]

var s_state: dict<any> = {}
var s_timer = -1

def Center(text: string, width: number): string
  return repeat(' ', max([0, (width - strwidth(text)) / 2])) .. text
enddef

def Paint(lnum: number, type: string)
  const n = len(getline(lnum))
  if n > 0 | prop_add(lnum, 1, {length: n, type: type}) | endif
enddef

def Stop()
  if s_timer != -1 | timer_stop(s_timer) | s_timer = -1 | endif
enddef

# Reveal the current message one scramble frame at a time, hold, then rotate.
def Step(_: number)
  if empty(s_state) || bufnr('%') != s_state.buf || &buftype != 'nofile'
    Stop()
    return
  endif
  s_state.frame += 1
  const chars: list<string> = s_state.chars
  const reveal = s_state.frame * s_speed
  if reveal > len(chars) + s_hold
    s_state.index = (s_state.index + 1) % len(s_msgs)
    s_state.chars = split(s_msgs[s_state.index], '\zs')
    s_state.frame = 0
    return
  endif
  var display = ''
  var i = 0
  for c in chars
    display ..= (i < reveal || c == ' ') ? c : s_chars[rand() % len(s_chars)]
    i += 1
  endfor
  const modifiable = &l:modifiable
  setlocal modifiable
  setline(s_state.lnum, Center(display, s_state.width))
  prop_remove({type: 'StartScreenMsg', all: true}, s_state.lnum)
  Paint(s_state.lnum, 'StartScreenMsg')
  if !modifiable | setlocal nomodifiable | endif
  redraw
enddef

def Cycle(buf: number, lnum: number, width: number)
  Stop()
  const index = localtime() % len(s_msgs)
  s_state = {buf: buf, lnum: lnum, width: width,
    \ index: index, chars: split(s_msgs[index], '\zs'), frame: 0}
  Step(0)
  s_timer = timer_start(45, Step, {repeat: -1})
enddef

def g:StartScreenRender()
  Stop()
  const width = winwidth(0)
  const modifiable = &l:modifiable
  setlocal modifiable
  silent :% delete _
  prop_clear(1, line('$'))
  append(0, repeat([''], max([0, (winheight(0) - len(s_art) - 6) / 2])))
  for art in s_art
    append(line('$'), Center(art, width))
    Paint(line('$'), 'StartScreenArt')
  endfor
  append(line('$'), ['', '', '', ''])
  const msg_line = line('$') - 1
  cursor(1, 1)
  if !modifiable | setlocal nomodifiable | endif
  redraw!
  Cycle(bufnr('%'), msg_line, width)
  nnoremap <buffer> <silent> <Return> <Cmd>enew<Bar>call g:StartScreenStart()<CR>
  nnoremap <buffer> <silent> r        <Cmd>call g:StartScreenRender()<CR>
enddef

def g:StartScreenStart()
  if argc() || line2byte('$') != -1
      || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
    return
  endif
  enew
  setlocal bufhidden=wipe buftype=nofile nobuflisted nocursorcolumn
    \ nocursorline nolist nonumber noswapfile norelativenumber
  g:StartScreenRender()
  setlocal nomodifiable nomodified
  nnoremap <buffer> <silent> e <Cmd>enew<CR>
  nnoremap <buffer> <silent> r <Cmd>call g:StartScreenRender()<CR>
enddef

augroup startscreen
  autocmd!
  autocmd VimEnter * call g:StartScreenStart()
  autocmd VimResized * if &buftype ==# 'nofile' | call g:StartScreenRender() | endif
  autocmd WinEnter * if &buftype ==# 'nofile' && expand('%') == '' | call g:StartScreenRender() | endif
augroup END
