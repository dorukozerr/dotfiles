vim9script

# var git_stats_throttle = 0

# Git +/-/~ stats for the airline status line, throttled to once per 2s.
# export def g:GitStats(): string
#   if localtime() - git_stats_throttle < 2
#     return get(g:, 'GitStats', '')
#   endif
#   git_stats_throttle = localtime()
# 
#   var status = systemlist('git status --porcelain 2>/dev/null')
#   if v:shell_error
#     return ''
#   endif
# 
#   var files = status->filter((_, l) => l !~ '^!')->len()
#   var additions = 0
#   var deletions = 0
# 
#   for line in systemlist('git diff HEAD --numstat 2>/dev/null')
#         + systemlist('git diff --cached --numstat 2>/dev/null')
#     var stats = split(line)
#     if stats->len() >= 2
#       additions += str2nr(stats[0])
#       deletions += str2nr(stats[1])
#     endif
#   endfor
# 
#   for status_line in status
#     if status_line =~ '^??'
#       var file = substitute(status_line, '^??\s\+', '', '')
#       var file_content = systemlist('wc -l ' .. shellescape(file) .. ' 2>/dev/null')
#       if !empty(file_content)
#         additions += str2nr(split(file_content[0])[0])
#       endif
#     endif
#   endfor
# 
#   return printf('  +%d -%d 󱁻 %d', additions, deletions, files)
# enddef

export def GenerateLoremIpsum(count: number)
  const lorem_words = ['lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
        'adipiscing', 'elit', 'sed', 'do', 'eiusmod', 'tempor', 'incididunt',
        'ut', 'labore', 'et', 'dolore', 'magna', 'aliqua', 'enim', 'ad', 'minim',
        'veniam', 'quis', 'nostrud', 'exercitation', 'ullamco', 'laboris', 'nisi',
        'aliquip', 'ex', 'ea', 'commodo', 'consequat', 'duis', 'aute', 'irure',
        'in', 'reprehenderit', 'voluptate', 'velit', 'esse', 'cillum', 'fugiat',
        'nulla', 'pariatur', 'excepteur', 'sint', 'occaecat', 'cupidatat', 'non',
        'proident', 'sunt', 'culpa', 'qui', 'officia', 'deserunt', 'mollit',
        'anim', 'id', 'est', 'laborum']

  var result = []
  var word_count = count

  if word_count >= 2
    add(result, 'Lorem')
    add(result, 'ipsum')
    word_count -= 2
  elseif word_count == 1
    add(result, 'Lorem')
    word_count -= 1
  endif

  while word_count > 0
    add(result, lorem_words[rand() % len(lorem_words)])
    word_count -= 1
  endwhile

  execute 'normal! a' .. join(result, ' ') .. '.'
enddef

var window_zoomed = false
var window_layout = {}

export def BufferToggle()
  if !window_zoomed
    window_layout = {
          width: winwidth(0),
          height: winheight(0),
          win_count: winnr('$')
          }
    if window_layout.win_count > 1
      resize
      vertical resize
      window_zoomed = true
    endif
  else
    wincmd w
    window_zoomed = false
  endif
enddef

export def BufferDeleteCurrent()
  if &filetype ==# 'netrw' && winnr('$') == 1 && tabpagenr('$') == 1
    return
  endif

  var buf = bufnr('%')
  var shown = getwininfo()->filter((_, w) => w.bufnr == buf)->len()

  if shown > 1
    close
    return
  endif

  var listed = buflisted(buf)
  var force = ''
  if listed && getbufvar(buf, '&modified')
    if confirm("Unsaved changes. Discard?", "&Yes\n&No", 2, "W") != 1
      return
    endif
    force = '!'
  endif

  if winnr('$') == 1 && tabpagenr('$') == 1
    if range(1, bufnr('$'))->filter((_, n) => buflisted(n))->len() <= 1
      execute 'qall' .. force
      return
    endif
    if listed
      silent! execute 'bdelete' .. force .. ' ' .. buf
    else
      bprevious
    endif
    return
  endif

  close

  if bufexists(buf) && buflisted(buf)
    silent! execute 'bdelete' .. force .. ' ' .. buf
  endif
enddef

def AirlineThemesList(): list<string>
  return globpath(&rtp, 'autoload/airline/themes/*.vim', 0, 1)
        ->map((_, val) => fnamemodify(val, ':t:r'))
enddef

def AirlineThemesExit(fifo: string, original: string, code: number): void
  if code > 0 && !empty(original)
    execute 'AirlineTheme ' .. original
  endif
  fzf#vim#ipc#stop(fifo)
enddef

export def AirlineThemes(bang: bool)
  var themes = AirlineThemesList()
  var original = ''

  if exists('g:airline_theme')
    original = g:airline_theme
    themes = [original] + themes->filter((_, t) => t != original)
  endif

  var spec = {
    source: themes,
    sink: 'AirlineTheme',
    options: ['+m', '--prompt', 'AirlineThemes> ']
  }

  if !bang
    var fifo = fzf#vim#ipc#start((msg) => execute('AirlineTheme ' .. msg))
    if !empty(fifo)
      spec.options->extend(['--no-tmux', '--no-padding', '--no-margin', '--bind',
            'focus:execute-silent:printf ''%s\n'' {} > ' .. fzf#shellescape(fifo)])
      spec.exit = function('AirlineThemesExit', [fifo, original])
      var maxwidth = max(themes->copy()->map((_, t) => strwidth(t)))
      spec.window = { width: maxwidth + 8, height: len(themes) + 5 }
    endif
  endif

  fzf#run(fzf#wrap(spec))
enddef

export def ResizeH(direction: string, amount: number)
  var at_right_edge = winnr() == winnr('l')

  if direction ==# 'left'
    execute 'vertical resize ' .. (at_right_edge ? '+' .. amount : '-' .. amount)
  else
    execute 'vertical resize ' .. (at_right_edge ? '-' .. amount : '+' .. amount)
  endif
enddef

export def ResizeV(direction: string, amount: number)
  var at_bottom_edge = winnr() == winnr('j')

  if direction ==# 'up'
    execute 'resize ' .. (at_bottom_edge ? '+' .. amount : '-' .. amount)
  else
    execute 'resize ' .. (at_bottom_edge ? '-' .. amount : '+' .. amount)
  endif
enddef

export def Scratch(cmd: string)
  execute 'ene! | setlocal buftype=nofile bufhidden=wipe noswapfile | r  !' .. cmd
enddef

export def ParseVimScript(cmd: string)
  execute 'ene! | setlocal buftype=nofile bufhidden=wipe noswapfile | r  !vimparse' .. %
enddef


# export def GitRestoreCurrent()
#   var current_file = expand('%:p')
# 
#   if empty(current_file)
#     echo 'No file in current buffer'
#     return
#   endif
# 
#   execute 'G restore ' .. current_file
# enddef

# export def CleanFileLineEndings()
#   edit ++enc=utf-8
# 
#   setlocal nobomb
#   setlocal fileformat=unix
# 
#   :%s/\r//ge
#   :%s/[^\x00-\x7F]//ge
# 
#   update
#   edit!
# 
#   echo 'File cleaned and reloaded.'
# enddef

# augroup _update_git_stats
#   autocmd!
#   # autocmd BufWritePost * g:GitStats = GitStats()
#   # autocmd VimEnter * g:GitStats = GitStats()
# augroup END
