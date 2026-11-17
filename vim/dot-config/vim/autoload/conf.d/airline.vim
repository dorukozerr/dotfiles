vim9script

g:airline_left_sep =  ''
g:airline_right_sep = ''
g:airline#extensions#tabline#left_sep  = ''
g:airline#extensions#tabline#right_sep = ''

g:airline#extensions#tabline#enabled   = 1
g:airline#extensions#tabline#formatter = 'short_path_improved'

g:airline_powerline_fonts = 0

g:webdevicons_enable_airline_statusline = 0
g:webdevicons_enable_airline_statusline_fileformat = -1

g:airline_section_a = airline#section#create_left(['mode'])
g:airline_section_b = airline#section#create(['%t %m'])
g:airline_section_c = airline#section#create([' '])
g:airline_section_x = airline#section#create(['filetype', ' ', '%{WebDevIconsGetFileTypeSymbol()}', ' '])
g:airline_section_y = airline#section#create([' %{empty(FugitiveHead()) ? "Git Gud" : FugitiveHead()}%{get(g:, "git_stats", "")}'])
g:airline_section_z = airline#section#create(['%l:%c/%L'])""
