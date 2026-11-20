vim9script

if exists('$TMUX')
  g:fzf_layout = { tmux: '-p100%,100%' }
else
  g:fzf_layout = { window: { width: 1, height: 1 } }
endif

# fzf.vim hardcodes :Rg and :RG without --follow, so matches inside symlinked
# directories never show up. Instead of overriding them, define follow
# variants via the documented functions (:h fzf-vim-vim-functions).
command! -bang -nargs=* RgFollow call fzf#vim#grep(
      \ "rg --column --line-number --no-heading --color=always --smart-case --follow -- "
      \ .. fzf#shellescape(<q-args>), 
      \ fzf#vim#with_preview(), <bang>0 )

command! -bang -nargs=* RGFollow call fzf#vim#grep2(
      \ "rg --column --line-number --no-heading --color=always --smart-case --follow -- ", 
      \ <q-args>, 
      \ fzf#vim#with_preview(), <bang>0)
