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
nnoremap <Leader>t :Explore<CR>

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

" increase/decrease pane width and height
nnoremap <Leader>ipw :vertical resize +10<CR>
nnoremap <Leader>dpw :vertical resize -10<CR>
nnoremap <Leader>iph :resize +10<CR>
nnoremap <Leader>dph :resize -10<CR>

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

" Copying and yank improvements, yank registers into system clipboard and `gp`
" mappings do paste from system clipboard
nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y
nnoremap gp i<C-r><C-o>+<Esc>
vnoremap gp "_c<C-r><C-o>+<Esc>

" Man pages search
nnoremap <leader>ms :ManSearch <C-r><right>

" Clear/Reset file
nnoremap <leader>cfe :call CleanFileLineEndings()<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" https://github.com/neoclide/coc.nvim?tab=readme-ov-file#example-vim-configuration
"
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to
" enable no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <leader><CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-@> coc#refresh()

" Use `[g` and `]g` to navigate diagnostics Use `:CocDiagnostics` to get all
" diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming
nmap <leader>rns <Plug>(coc-rename)
" File Rename
nmap <leader>rnf :CocCommand workspace.renameCurrentFile<CR>

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language
" server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges Requires 'textDocument/selectionRange'
" support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Copy type definition
nnoremap <Leader>ccd :call CocCopyDefinition()<CR>
