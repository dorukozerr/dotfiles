vim9script

const Red   = '#a8433c'
const White = '#c1c1c1'
const Grey  = '#888888'
const Dim   = '#333333'
const Bg    = '#000000'
const Bg2   = '#222222'

def Apply()
  execute 'hi! LspDiagInlineError   gui=undercurl cterm=undercurl guisp=' .. Red
  execute 'hi! LspDiagInlineWarning gui=undercurl cterm=undercurl guisp=' .. White
  execute 'hi! LspDiagInlineInfo    gui=undercurl cterm=undercurl guisp=' .. Grey
  execute 'hi! LspDiagInlineHint    gui=undercurl cterm=undercurl guisp=' .. Dim

  hi! clear LspDiagLine

  execute 'hi! LspDiagSignErrorText   guifg=' .. Red   .. ' ctermfg=1'
  execute 'hi! LspDiagSignWarningText guifg=' .. White .. ' ctermfg=7'
  execute 'hi! LspDiagSignInfoText    guifg=' .. Grey  .. ' ctermfg=8'
  execute 'hi! LspDiagSignHintText    guifg=' .. Dim   .. ' ctermfg=8'

  execute 'hi! LspDiagVirtualText        gui=italic guifg=' .. Dim
  execute 'hi! LspDiagVirtualTextError   gui=italic guifg=' .. Red
  execute 'hi! LspDiagVirtualTextWarning gui=italic guifg=' .. White
  execute 'hi! LspDiagVirtualTextInfo    gui=italic guifg=' .. Grey
  execute 'hi! LspDiagVirtualTextHint    gui=italic guifg=' .. Dim

  execute 'hi! LspPopup        guifg=' .. Red   .. ' guibg=' .. Bg .. ' ctermfg=3 ctermbg=0'
  execute 'hi! LspPopupBorder  guifg=' .. Red   .. ' guibg=' .. Bg .. ' ctermfg=3 ctermbg=0'
  execute 'hi! LspSigActiveParameter gui=undercurl cterm=undercurl guisp=' .. White

  execute 'hi! LspSymbolName  guifg=' .. Bg   .. ' guibg=' .. Red .. ' ctermfg=0 ctermbg=1'
  hi! link LspSymbolRange Visual

  execute 'hi! LspInlayHintsType gui=italic guifg=' .. Dim .. ' ctermfg=8'
  execute 'hi! LspInlayHintsParam gui=italic guifg=' .. Dim .. ' ctermfg=8'

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

  execute 'hi! QuickFixLine guifg=' .. White .. ' guibg=' .. Bg2 .. ' ctermfg=7 ctermbg=8'
enddef

def TransparentBg()
  hi! Normal      guibg=NONE ctermbg=NONE
  hi! NonText     guibg=NONE ctermbg=NONE
  hi! SignColumn  guibg=NONE ctermbg=NONE
  hi! EndOfBuffer guibg=NONE ctermbg=NONE
enddef

export def AddConf()
  set termguicolors
  set background=dark

  augroup Theming
    autocmd!
    autocmd ColorScheme * Apply()
    autocmd ColorScheme * TransparentBg()
  augroup END

  colorscheme base16-black-metal-venom
  Apply()
enddef
