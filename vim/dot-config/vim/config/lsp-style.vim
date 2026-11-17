let s:red   = '#a8433c'
let s:white = '#c1c1c1'
let s:grey  = '#888888'
let s:dim   = '#333333'
let s:bg    = '#000000'
let s:bg1   = '#121212'
let s:bg2   = '#222222'

function! s:Apply() abort
  execute 'hi! LspDiagInlineError   gui=undercurl cterm=undercurl guisp=' . s:red
  execute 'hi! LspDiagInlineWarning gui=undercurl cterm=undercurl guisp=' . s:white
  execute 'hi! LspDiagInlineInfo    gui=undercurl cterm=undercurl guisp=' . s:grey
  execute 'hi! LspDiagInlineHint    gui=undercurl cterm=undercurl guisp=' . s:dim
  hi! clear LspDiagLine

  execute 'hi! LspDiagSignErrorText   guifg=' . s:red   . ' ctermfg=1'
  execute 'hi! LspDiagSignWarningText guifg=' . s:white . ' ctermfg=7'
  execute 'hi! LspDiagSignInfoText    guifg=' . s:grey  . ' ctermfg=8'
  execute 'hi! LspDiagSignHintText    guifg=' . s:dim   . ' ctermfg=8'

  execute 'hi! LspDiagVirtualText        gui=italic guifg=' . s:dim
  execute 'hi! LspDiagVirtualTextError   gui=italic guifg=' . s:red
  execute 'hi! LspDiagVirtualTextWarning gui=italic guifg=' . s:white
  execute 'hi! LspDiagVirtualTextInfo    gui=italic guifg=' . s:grey
  execute 'hi! LspDiagVirtualTextHint    gui=italic guifg=' . s:dim

  execute 'hi! LspPopup        guifg=' . s:red   . ' guibg=' . s:bg . ' ctermfg=3 ctermbg=0'
  execute 'hi! LspPopupBorder  guifg=' . s:red   . ' guibg=' . s:bg . ' ctermfg=3 ctermbg=0'
  execute 'hi! LspSigActiveParameter gui=undercurl cterm=undercurl guisp=' . s:white

  execute 'hi! LspSymbolName  guifg=' . s:bg   . ' guibg=' . s:red . ' ctermfg=0 ctermbg=1'
  hi! link LspSymbolRange Visual

  execute 'hi! LspInlayHintsType gui=italic guifg=' .  s:dim . ' ctermfg=8'
  execute 'hi! LspInlayHintsParam gui=italic guifg=' . s:dim . ' ctermfg=8'

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

  execute 'hi! QuickFixLine guifg=' . s:white . ' guibg=' . s:bg2 . ' ctermfg=7 ctermbg=8'
endfunction

call s:Apply()
augroup LspStyle
  autocmd!
  autocmd ColorScheme * call s:Apply()
augroup END
