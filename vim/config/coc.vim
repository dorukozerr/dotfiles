" https://github.com/neoclide/coc.nvim?tab=readme-ov-file#example-vim-configuration

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <leader><CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

augroup rust_maps
  autocmd!
  autocmd FileType rust nnoremap <buffer> <leader>rm: CocCommand rust-analyzer.expandMacro<CR>
  autocmd FileType rust nnoremap <buffer> <leader>rd: CocCommand rust-analyzer.openDocs<CR>
  autocmd FileType rust nnoremap <buffer> <leader>rp: CocCommand rust-analyzer.parentModule<CR>
  autocmd FileType rust nnoremap <buffer> <leader>rr: CocCommand rust-analyzer.run<CR>
  autocmd FileType rust nnoremap <buffer> <leader>re: CocCommand rust-analyzer.explainError<CR>
  autocmd FileType rust nnoremap <buffer> <leader>rj: CocCommand rust-analyzer.joinLines<CR>
  autocmd FileType rust nnoremap <buffer> <leader>rh: CocCommand document.toggleInlayHint<CR>
  autocmd FileType rust xnoremap <buffer> <leader>rj: <C-u>CocCommand rust-analyzer.joinLines<CR>
augroup END

func! s:InlayHintColors() abort
  highlight CocInlayHint          guifg=#3a3f4b guibg=NONE gui=italic ctermfg=238 cterm=italic
  highlight CocInlayHintType      guifg=#3a3f4b guibg=NONE gui=italic ctermfg=238 cterm=italic
  highlight CocInlayHintParameter guifg=#32363f guibg=NONE gui=italic ctermfg=237 cterm=italic
endfunc

augroup InlayHintColors
  autocmd!
  autocmd ColorScheme * call s:InlayHintColors()
augroup END

call s:InlayHintColors()
