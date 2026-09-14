runtime! ftplugin/man.vim
packadd! matchit

scriptencoding utf-8

filetype plugin indent on
syntax enable

set termguicolors
set updatetime=300
set signcolumn=yes
set encoding=utf-8
set backspace=indent,eol,start
set fillchars=eob:\ ,vert:\|
set hlsearch
set wrap
set nu rnu
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set incsearch
set noswapfile
set foldmethod=syntax
set foldenable
set foldlevelstart=99
set title
set titlestring=%{substitute(getcwd(),\ $HOME,\ '~',\ '')}
set t_BE=
set autoread
set clipboard=unnamedplus
" set diffopt+=internal,algorithm:patience,indent-heuristic

let g:coc_node_path = "/Users/suqoi/.vite-plus/bin/node"

autocmd FocusGained,BufEnter * checktime

set background=dark
" colorscheme base24-solarized-dark-higher-contrast
colorscheme elflord
" colorscheme base24-wez

" hi Normal guibg=NONE ctermbg=NONE
" hi NonText guibg=NONE ctermbg=NONE
" hi SignColumn guibg=NONE ctermbg=NONE
" hi EndOfBuffer guibg=NONE ctermbg=NONE

function! s:InlayHintColors() abort
  highlight CocInlayHint          guifg=#3a3f4b guibg=NONE gui=italic ctermfg=238 cterm=italic
  highlight CocInlayHintType      guifg=#3a3f4b guibg=NONE gui=italic ctermfg=238 cterm=italic
  highlight CocInlayHintParameter guifg=#32363f guibg=NONE gui=italic ctermfg=237 cterm=italic
endfunction

augroup InlayHintColors
  autocmd!
  autocmd ColorScheme * call s:InlayHintColors()
augroup END

call s:InlayHintColors()
