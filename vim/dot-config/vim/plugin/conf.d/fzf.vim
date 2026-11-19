vim9script

# $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob \"!.git/*"'

if exists('$TMUX')
        g:fzf_layout = { tmux: '-p100%,100%' }
else
        g:fzf_layout = { window: { width: 1, height: 1 } }
endif

def FzfStatusLine()
        highlight fzf1 ctermfg=161 ctermbg=251
        highlight fzf2 ctermfg=23 ctermbg=251
        highlight fzf3 ctermfg=237 ctermbg=251
        setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
enddef

au! User FzfStatusLine call FzfStatusLine()
