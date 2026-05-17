vim9script

g:sneak#label = 1
g:sneak#s_next = 1
g:sneak#prompt = '󰮇 '

map s <Plug>Sneak_s
map S <Plug>Sneak_S

hi! link Sneak Search
hi! link SneakCurrent CurSearch
hi! SneakLabel ctermfg=0 ctermbg=3 cterm=bold
hi! SneakLabelMask ctermfg=8 ctermbg=1 cterm=NONE
