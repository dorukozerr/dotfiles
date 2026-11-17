let g:airline_theme = 'ahmet_ikiz'
"i autocmd! FileType fzf set laststatus=0 noshowmode noruler
"       \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
" let g:airline#extensions#quickfix#location_text = 'Location'
" 
" let g:airline#extensions#searchcount#enabled = 1
" let g:airline#extensions#searchcount#show_search_term = 1
" let g:airline#extensions#searchcount#search_term_limit = 8
" " 
" let g:airline#extensions#tabline#enabled = 1
" 
" let g:airline#extensions#vim9lsp#enabled = 1
" let g:airline#extensions#vim9lsp#error_symbol = 'E:'
" let g:airline#extensions#vim9lsp#warning_symbol = 'W:'

" " let g:airline_theme='base16_default'
" " let g:airline_theme='base16_solarized'
" " let g:airline_theme='base16_grayscale'
" let g:airline_theme='base16_black_metal_venom'

let g:airline_left_sep=''
let g:airline_right_sep=''

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='short_path_improved'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#right_sep = ''

let g:airline_powerline_fonts = 0

let g:webdevicons_enable_airline_statusline=0
let g:webdevicons_enable_airline_statusline_fileformat=-1
" 
let g:airline_section_a = airline#section#create_left(['mode'])
let g:airline_section_b = airline#section#create(['%t %m'])
let g:airline_section_c = airline#section#create([' '])
let g:airline_section_x = airline#section#create(['filetype', ' ', '%{WebDevIconsGetFileTypeSymbol()}', ' '])
let g:airline_section_y = airline#section#create([' %{empty(FugitiveHead()) ? "Git Gud" : FugitiveHead()}%{get(g:, "git_stats", "")}'])
let g:airline_section_z = airline#section#create(['%l:%c/%L'])"" 
