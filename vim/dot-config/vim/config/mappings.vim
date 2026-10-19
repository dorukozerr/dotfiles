" reset leader key
let mapleader = "\<Space>"

set ttimeout
set ttimeoutlen=10

" gotta develop that muscle memory, one way or another Note after months of
" enabling this mappings, it was the best decision in my life, no joke
noremap <up> :echoerr "Senpai, use k instead"<CR>
noremap <down> :echoerr "Senpai, use j instead"<CR>
noremap <left> :echoerr "Senpai, use h instead"<CR>
noremap <right> :echoerr "Senpai, use l instead"<CR>

inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

nnoremap j gj
nnoremap k gk

" fugitive
nnoremap <Leader>gs :G status<CR>
nnoremap <Leader>ga :G add .<CR>
nnoremap <Leader>gc :vertical G commit<CR>
nnoremap <Leader>gp :G push<CR>
nnoremap <Leader>gd :vertical G diff<CR>
nnoremap <Leader>gr :call GitRestoreCurrent()<CR>

" open netrw
nnoremap <Leader>t :Explore %:p:h<CR>

" kisuke
nnoremap <Leader>ko :KisukeOpen<CR>
nnoremap <Leader>krs :KisukeResumeLastSession<CR>
nnoremap <Leader>km :KisukeMarkFocusedFile<CR>
vnoremap <Leader>kh :KisukeMarkHighlighted<CR>
nnoremap <leader>krc :KisukeRemoveLastMarkedCodeBlock<CR>
nnoremap <Leader>kc :KisukeCreateNewSession<CR>
nnoremap <Leader>kd :KisukeDeleteSession<CR>
nnoremap <Leader>krp :KisukeRestart<CR>
nnoremap <Leader>kns :KisukeNextSession<CR>
nnoremap <Leader>kps :KisukePreviousSession<CR>

" fzf
nnoremap <Leader>p :Files<CR>
nnoremap <Leader>f :RG<CR>
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>gl :Commits<CR>
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')
nnoremap <Leader>gpa :GitStage<CR>
nnoremap <Leader>c :Commands<CR>

" thank you AI
execute "set <M-s>=\<Esc>s"
execute "set <M-v>=\<Esc>v"
execute "set <M-h>=\<Esc>h"
execute "set <M-j>=\<Esc>j"
execute "set <M-k>=\<Esc>k"
execute "set <M-l>=\<Esc>l"
execute "set <M-n>=\<Esc>n"
execute "set <M-p>=\<Esc>p"
execute "set <M-q>=\<Esc>q"
execute "set <M-z>=\<Esc>z"
execute "set <M-,>=\<Esc>,"
execute "set <M-.>=\<Esc>."
execute "set <M-g>=\<Esc>g"

nnoremap <silent> <M-s> :split<CR>
nnoremap <silent> <M-v> :vsplit<CR>

nnoremap <expr> <M-h> winnr('h') == winnr() ? "999\<C-w>l" : "\<C-w>h"
nnoremap <expr> <M-l> winnr('l') == winnr() ? "999\<C-w>h" : "\<C-w>l"
nnoremap <expr> <M-j> winnr('j') == winnr() ? "999\<C-w>k" : "\<C-w>j"
nnoremap <expr> <M-k> winnr('k') == winnr() ? "999\<C-w>j" : "\<C-w>k"

nnoremap <silent> <M-n> :bnext<CR>
nnoremap <silent> <M-p> :bprevious<CR>
nnoremap <silent> <M-q> :call BufferDeleteCurrent()<CR>
nnoremap <silent> <M-z> :call BufferToggle()<CR>

nnoremap <silent> <M-Left>  :call ResizeH('left', '5')<CR>
nnoremap <silent> <M-Right> :call ResizeH('right', '5')<CR>
nnoremap <silent> <M-Up>    :call ResizeV('up', '5')<CR>
nnoremap <silent> <M-Down>  :call ResizeV('down', '5')<CR>

nnoremap <silent> <M-,> :tabprevious<CR>
nnoremap <silent> <M-.> :tabnext<CR>

nnoremap <silent> <M-g> :G<CR>

" save file
nnoremap <leader>s :w<CR>

" Auto-center screen after search navigation
nnoremap <silent> n nzz
nnoremap <silent> N Nzz

" clipboard_provider on macOS doesn't sync pure yanks via unnamedplus
nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y

" gp pastes without moving cursor to end (insert-literal from clipboard)
nnoremap gp i<C-r><C-o>+<Esc>
vnoremap gp "_c<C-r><C-o>+<Esc>

" This one is really weird, I'm not saying something but I'm paranoid person
" this was SUS - Clear/Reset file
nnoremap <leader>cfe :call CleanFileLineEndings()<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
