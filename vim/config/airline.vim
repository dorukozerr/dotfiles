let g:airline_skip_empty_sections=1
let g:airline_highlighting_cache=1
let g:airline_theme='simple_black_metal'
let g:airline_powerline_fonts = 0

let g:webdevicons_enable_airline_statusline=0
let g:webdevicons_enable_airline_statusline_fileformat=0

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline_section_a = airline#section#create_left(['mode'])
let g:airline_section_b = airline#section#create(['%t %m'])
let g:airline_section_c = airline#section#create([' '])
let g:airline_section_x = airline#section#create(['filetype', ' ', '%{WebDevIconsGetFileTypeSymbol()}', ' '])
let g:airline_section_y = airline#section#create([' %{empty(FugitiveHead()) ? "Git Gud" : FugitiveHead()}%{get(g:, "git_stats", "")}'])
let g:airline_section_z = airline#section#create(['%l:%c/%L'])
