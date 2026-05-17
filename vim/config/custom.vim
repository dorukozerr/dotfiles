vim9script

var git_stats_throttle: number = 0

def g:GitStats(): string
  if localtime() - git_stats_throttle < 2
    return get(g:, 'git_stats', '')
  endif

  git_stats_throttle = localtime()
  var status = system('git status --porcelain 2>/dev/null')

  if v:shell_error != 0
    return ''
  endif

  var files = len(filter(split(status, '\n'), (_, v) => v !~ '^!'))
  var additions = 0
  var deletions = 0
  var diff = system('git diff HEAD --numstat 2>/dev/null')

  for line in split(diff, '\n')
    var stats = split(line)
    if len(stats) >= 2
      additions += str2nr(stats[0])
      deletions += str2nr(stats[1])
    endif
  endfor

  var staged_diff = system('git diff --cached --numstat 2>/dev/null')

  for line in split(staged_diff, '\n')
    var stats = split(line)
    if len(stats) >= 2
      additions += str2nr(stats[0])
      deletions += str2nr(stats[1])
    endif
  endfor

  for status_line in split(status, '\n')
    if status_line =~ '^??'
      var file = substitute(status_line, '^??\s\+', '', '')
      var file_content = system('wc -l ' .. shellescape(file) .. ' 2>/dev/null')
      if v:shell_error == 0
        additions += str2nr(split(file_content)[0])
      endif
    endif
  endfor

  return printf('  +%d -%d 󱁻 %d', additions, deletions, files)
enddef

augroup GitStatsUpdate
  autocmd!
  autocmd BufWritePost,VimEnter,BufEnter,BufLeave * {
    g:git_stats = g:GitStats()
  }
augroup END

def g:GenerateLoremIpsum(count: number)
  var lorem_words = ['lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur',
    'adipiscing', 'elit', 'sed', 'do', 'eiusmod', 'tempor', 'incididunt',
    'ut', 'labore', 'et', 'dolore', 'magna', 'aliqua', 'enim', 'ad', 'minim',
    'veniam', 'quis', 'nostrud', 'exercitation', 'ullamco', 'laboris', 'nisi',
    'aliquip', 'ex', 'ea', 'commodo', 'consequat', 'duis', 'aute', 'irure',
    'in', 'reprehenderit', 'voluptate', 'velit', 'esse', 'cillum', 'fugiat',
    'nulla', 'pariatur', 'excepteur', 'sint', 'occaecat', 'cupidatat', 'non',
    'proident', 'sunt', 'culpa', 'qui', 'officia', 'deserunt', 'mollit',
    'anim', 'id', 'est', 'laborum']

  var result: list<string> = []
  var word_count = count

  if word_count >= 2
    result->add('Lorem')
    result->add('ipsum')
    word_count -= 2
  elseif word_count == 1
    result->add('Lorem')
    word_count -= 1
  endif

  while word_count > 0
    var random_index = rand() % len(lorem_words)
    result->add(lorem_words[random_index])
    word_count -= 1
  endwhile

  var text = join(result, ' ') .. '.'
  execute 'normal! a' .. text
enddef
command! -nargs=1 Lorem call g:GenerateLoremIpsum(<args>)

g:window_zoomed = 0
g:window_layout = {}

def g:BufferToggle()
  if g:window_zoomed == 0
    g:window_layout = {
      width: winwidth(0),
      height: winheight(0),
      win_count: winnr('$'),
    }
    if g:window_layout.win_count > 1
      resize
      vertical resize
      g:window_zoomed = 1
    endif
  else
    wincmd =
      g:window_zoomed = 0
  endif
enddef

def g:BufferDeleteCurrent()
  if len(filter(range(1, bufnr('$')), (_, v) => buflisted(v))) <= 1
    echo 'Cannot delete the last buffer'
    return
  endif

  var current_buf = bufnr('%')

  if bufnr('#') != -1 && buflisted(bufnr('#'))
    buffer #
  elseif exists(':bprevious')
    bprevious
  else
    bnext
  endif

  execute 'bdelete ' .. current_buf
enddef

def g:CleanFileLineEndings()
  edit ++enc=utf-8

  set nobomb
  set fileformat=unix

  :%s/\r//g
  :%s/[^\x00-\x7F]//g

  update
  edit!

  echo 'File cleaned and reloaded.'
enddef

def g:GitRestoreCurrent()
  var current_file = expand('%:p')

  if empty(current_file)
    echo 'No file in current buffer'
    return
  endif

  execute 'G restore ' .. current_file
enddef
