" reset leader key
let mapleader = "\<Space>"

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

" buffers
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <Leader>bt :call BufferToggle()<CR>
nnoremap <leader>bda :%bdelete<Bar>edit #<Bar>normal`"<CR>
nnoremap <Leader>bdc :call BufferDeleteCurrent()<CR>

" window splits
nnoremap <Leader>vs :vsplit<CR>

" navigate buffers with Ctrl+Left/Right; jumps to the window already showing
" that buffer if one exists, otherwise opens it in the current split
nnoremap <C-Left>  :call SmartBufNav(-1)<CR>
nnoremap <C-Right> :call SmartBufNav(1)<CR>

" grow/shrink current split with Cmd+arrow
nnoremap <D-Right> :vertical resize +10<CR>
nnoremap <D-Left>  :vertical resize -10<CR>
nnoremap <D-Up>    :resize +10<CR>
nnoremap <D-Down>  :resize -10<CR>

" run precommit script
nnoremap <leader>rp :Precommit<CR>

" save file
nnoremap <leader>s :w<CR>

" Replace the world under cursor globally inside the buffer
nnoremap <leader>wr :%s/\<<C-r><C-w>\>//g<left><left>

" Replace the selected content in visual mode globally inside the buffer
vnoremap <leader>pr y:%s/\V<C-r>=escape(@", '/\')<CR>//g<Left><Left>

" Replace the selected content in visual mode globally inside the buffer also
" enter selected content into new replace value field
vnoremap <leader>pa y:%s/\V<C-r>=escape(@", '/\')<CR>/<C-r>=escape(@", '/\&~')<CR>/g<Left><Left>

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

" Man pages search
nnoremap <leader>ms :ManSearch <C-r><right>

" Clear/Reset file
nnoremap <leader>cfe :call CleanFileLineEndings()<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
