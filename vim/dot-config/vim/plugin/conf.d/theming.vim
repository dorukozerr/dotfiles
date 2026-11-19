vim9script

def ThemePatch()
  hi! Normal      guibg=NONE    ctermbg=NONE
  hi! NonText     guibg=NONE    ctermbg=NONE
  hi! SignColumn  guibg=NONE    ctermbg=NONE
  hi! EndOfBuffer guibg=NONE    ctermbg=NONE
  # hi! Comment     guifg=#888888 ctermbg=4
  # hi! vim9Comment guifg=#888888 ctermbg=4
enddef

aug _theming_patch
  au!
  au ColorScheme * ThemePatch()
aug END

colorscheme base16-black-metal-venom
