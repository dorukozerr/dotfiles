vim9script

export def AddConf()
  set termguicolors
  set background=dark

  colorscheme base16-black-metal-venom

  var red   = '#a8433c'
  var white = '#c1c1c1'
  var grey  = '#888888'
  var dim   = '#333333'
  var bg    = '#000000'
  var bg1   = '#121212'
  var bg2   = '#222222'

   hi! LspDiagInlineError   gui=undercurl cterm=undercurl guisp=' . re
   hi! LspDiagInlineWarning gui=undercurl cterm=undercurl guisp=' . whit
   hi! LspDiagInlineInfo    gui=undercurl cterm=undercurl guisp=' . gre
   hi! LspDiagInlineHint    gui=undercurl cterm=undercurl guisp=' . di

  hi! clear LspDiagLine

  hi! LspDiagSignErrorText   guifg=' . red   . ' ctermfg=1
  hi! LspDiagSignWarningText guifg=' . white . ' ctermfg=7
  hi! LspDiagSignInfoText    guifg=' . grey  . ' ctermfg=8
  hi! LspDiagSignHintText    guifg=' . dim   . ' ctermfg=8

   hi! LspDiagVirtualText        gui=italic guifg=' . di
   hi! LspDiagVirtualTextError   gui=italic guifg=' . re
   hi! LspDiagVirtualTextWarning gui=italic guifg=' . whit
   hi! LspDiagVirtualTextInfo    gui=italic guifg=' . gre
   hi! LspDiagVirtualTextHint    gui=italic guifg=' . di

  hi! LspPopup        guifg=' . red   . ' guibg=' . bg . ' ctermfg=3 ctermbg=0
  hi! LspPopupBorder  guifg=' . red   . ' guibg=' . bg . ' ctermfg=3 ctermbg=0
   hi! LspSigActiveParameter gui=undercurl cterm=undercurl guisp=' . whit

  hi! LspSymbolName  guifg=' . bg   . ' guibg=' . red . ' ctermfg=0 ctermbg=1
  hi! link LspSymbolRange Visual

  hi! LspInlayHintsType gui=italic guifg=' .  dim . ' ctermfg=8
  hi! LspInlayHintsParam gui=italic guifg=' . dim . ' ctermfg=8

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

  hi! QuickFixLine guifg=' . white . ' guibg=' . bg2 . ' ctermfg=7 ctermbg=8

  aug BgTranspecyPatch
    au!
    au ColorScheme * {
    hi! Normal      guibg=NONE ctermbg=NONE
    hi! NonText     guibg=NONE ctermbg=NONE
    hi! SignColumn  guibg=NONE ctermbg=NONE
    hi! EndOfBuffer guibg=NONE ctermbg=NONE
    }
  aug END
enddef
