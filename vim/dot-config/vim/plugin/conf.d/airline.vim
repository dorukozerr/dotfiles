vim9script

g:airline_theme = 'ahmet_ikiz'

g:airline_left_sep =  ''
g:airline_right_sep = ''

g:airline#extensions#tabline#left_sep  = ''
g:airline#extensions#tabline#right_sep = ''
g:airline#extensions#tabline#enabled   = 1
g:airline#extensions#tabline#formatter = 'short_path_improved'

g:airline#extensions#vim9lsp#enabled = 1

g:airline#extensions#fugitiveline#enabled = 1
g:airline#extensions#branch#vcs_checks = ['untracked', 'dirty']


g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
g:airline#extensions#quickfix#location_text = 'Location'
