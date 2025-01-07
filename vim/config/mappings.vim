" reset leader key
let mapleader = "\<Space>"

" gotta develop that muscle memory, one way or another
noremap <up> :echoerr "Senpai, use k instead"<CR>
noremap <down> :echoerr "Senpai, use j instead"<CR>
noremap <left> :echoerr "Senpai, use h instead"<CR>
noremap <right> :echoerr "Senpai, use l instead"<CR>
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

" open netrw
nnoremap <Leader>t :Explore<CR>

" coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
inoremap <silent><expr> <C-j> coc#refresh()
inoremap <silent><expr> <C-k><C-i> coc#rpc#request('doHover', [])
nnoremap <silent><expr> <C-k><C-i> CocActionAsync('doHover')
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" fzf toggle
nnoremap <Leader>p :Files<CR>
nnoremap <Leader>f :Rg<CR>

" buffers
nnoremap <Leader>bn :bn<CR>
nnoremap <Leader>bp :bp<CR>
nnoremap <leader>bc :%bdelete<Bar>edit #<Bar>normal`"<CR>

" increase/decrease pane width
nnoremap <Leader>ipw :vertical resize +10<CR>
nnoremap <Leader>dpw :vertical resize -10<CR>

" increase/decrease pane height
nnoremap <Leader>iph :resize +10<CR>
nnoremap <Leader>dph :resize -10<CR>

" save file
nnoremap <leader>s :w<CR>
