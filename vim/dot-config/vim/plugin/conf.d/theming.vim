vim9script

set background=dark

colorscheme base16-black-metal-venom

&t_Cs = "\x1b[4:3m"
&t_Ce = "\x1b[4:0m"
&t_8u = "\x1b[58;2;%lu;%lu;%lum"

var Red      = '#a8433c'
var White    = '#c1c1c1'
var Grey     = '#888888'
var DarkGrey = '#333333'
var Bg       = '#000000'
var Bg2      = '#222222'

def ApplyTheme()
  hi! SpellBad gui=undercurl cterm=undercurl guisp=#ff5555

  execute $'hi! LspDiagInlineError   gui=undercurl cterm=undercurl guisp={Red}'
  execute $'hi! LspDiagInlineWarning gui=undercurl cterm=undercurl guisp={White}'
  execute $'hi! LspDiagInlineInfo    gui=undercurl cterm=undercurl guisp={Grey}'
  execute $'hi! LspDiagInlineHint    gui=undercurl cterm=undercurl guisp={Red}'

  execute $'hi! LspDiagSignErrorText   guifg={Red}   ctermfg=1'
  execute $'hi! LspDiagSignWarningText guifg={White} ctermfg=7'
  execute $'hi! LspDiagSignInfoText    guifg={Grey}  ctermfg=8'
  execute $'hi! LspDiagSignHintText    guifg={DarkGrey} ctermfg=8'

  execute $'hi! LspDiagVirtualText        gui=italic guifg={DarkGrey}'
  execute $'hi! LspDiagVirtualTextError   gui=italic guifg={Red}'
  execute $'hi! LspDiagVirtualTextWarning gui=italic guifg={White}'
  execute $'hi! LspDiagVirtualTextInfo    gui=italic guifg={Grey}'
  execute $'hi! LspDiagVirtualTextHint    gui=italic guifg={DarkGrey}'

  execute $'hi! LspPopup        guifg={Red}   guibg={Bg} ctermfg=3 ctermbg=0'
  execute $'hi! LspPopupBorder  guifg={Red}   guibg={Bg} ctermfg=3 ctermbg=0'
  execute $'hi! LspSigActiveParameter gui=undercurl cterm=undercurl guisp={White}'

  execute $'hi! LspSymbolName  guifg={Bg} guibg={Red} ctermfg=0 ctermbg=1'
  hi! link LspSymbolRange Visual

  execute $'hi! LspInlayHintsType gui=italic guifg={DarkGrey} ctermfg=8'
  execute $'hi! LspInlayHintsParam gui=italic guifg={DarkGrey} ctermfg=8'

  hi! link LspSemanticFunction      Function
  hi! link LspSemanticMethod        Function
  hi! link LspSemanticType          Type
  hi! link LspSemanticClass         Type
  hi! link LspSemanticStruct        Type
  hi! link LspSemanticEnum          Type
  hi! link LspSemanticInterface     Type
  hi! link LspSemanticTypeParameter Type
  hi! link LspSemanticNamespace     Type
  hi! link LspSemanticModifier      Type
  hi! link LspSemanticParameter     Identifier
  hi! link LspSemanticVariable      Identifier
  hi! link LspSemanticProperty      Identifier
  hi! link LspSemanticEvent         Identifier
  hi! link LspSemanticEnumMember    Constant
  hi! link LspSemanticKeyword       Keyword
  hi! link LspSemanticComment       Comment
  hi! link LspSemanticString        String
  hi! link LspSemanticNumber        Number
  hi! link LspSemanticRegexp        String
  hi! link LspSemanticOperator      Operator
  hi! link LspSemanticMacro         Macro
  hi! link LspSemanticDecorator     Macro

  execute $'hi! QuickFixLine guifg={White} guibg={Bg2} ctermfg=7 ctermbg=8'

  # Keep the background transparent (also after a colorscheme change)
  hi! Normal      guibg=NONE ctermbg=NONE
  hi! NonText     guibg=NONE ctermbg=NONE
  hi! SignColumn  guibg=NONE ctermbg=NONE
  hi! EndOfBuffer guibg=NONE ctermbg=NONE
enddef

ApplyTheme()

aug _theming_patch
  au!
  au ColorScheme * ApplyTheme()
aug END
