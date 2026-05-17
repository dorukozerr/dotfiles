vim9script

set completeopt=menuone,popup,noinsert,noselect
set completepopup=width:80,highlight:LspDocPopup,align:item,border:off

var LspOptions: dict<any> = {
  autoComplete: true,
  omniComplete: true,
  omniCompleteAllowBare: true,
  completionMatcher: 'fuzzy',
  completionKinds: true,
  showSignature: true,
  showDiagInPopup: true,
  snippetSupport: true,
  popupBorder: true,
  popupBorderCompletion: true,
}

var LspServers: list<dict<any>> = [
  {
    name: 'typescriptlang',
    filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
    path: '/Users/qweqwe/.vite-plus/bin/typescript-language-server',
    args: ['--stdio'],
    features: {documentFormatting: false},
  },
  {
    name: 'tailwindcss',
    filetype: ['html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte'],
    path: '/opt/homebrew/bin/tailwindcss-language-server',
    args: ['--stdio'],
  },
  {
    name: 'jsonls',
    filetype: ['json', 'jsonc'],
    path: '/opt/homebrew/bin/vscode-json-language-server',
    args: ['--stdio'],
    initializationOptions: {provideFormatter: false},
  },
  {
    name: 'htmlls',
    filetype: ['html'],
    path: '/opt/homebrew/bin/vscode-html-language-server',
    args: ['--stdio'],
    features: {documentFormatting: false},
  },
  {
    name: 'cssls',
    filetype: ['css', 'scss', 'less'],
    path: '/opt/homebrew/bin/vscode-css-language-server',
    args: ['--stdio'],
    features: {documentFormatting: false},
  },
  {
    name: 'oxlint',
    filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
    path: '/opt/homebrew/bin/oxlint',
    args: ['--lsp'],
  },
  {
    name: 'oxfmt',
    filetype: [
    'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
    'json', 'jsonc',
    'css', 'scss', 'less',
    'html',
    ],
    path: '/opt/homebrew/bin/oxfmt',
    args: ['--lsp'],
  },
  {
    name: 'bashls',
    filetype: ['bash', 'sh'],
    path: '/opt/homebrew/bin/bash-language-server',
    args: ['start'],
  },
  {
    name: 'vscode-markdown-server',
    filetype: ['markdown'],
    path: '/opt/homebrew/bin/vscode-markdown-language-server',
    args: ['--stdio'],
  },
  {
    name: 'gopls',
    filetype: 'go',
    path: '/opt/homebrew/bin/gopls',
    args: ['serve']
  },
]

var ActiveLspServers: list<dict<any>> = []
for server in LspServers
  if executable(server.path)
    ActiveLspServers->add(server)
  endif
endfor

augroup CustomLsp
  autocmd!
  autocmd User LspSetup {
    g:LspOptionsSet(LspOptions)
    g:LspAddServer(ActiveLspServers)
  }
  autocmd User LspAttached {
    setlocal omnifunc=g:LspOmniFunc
    setlocal tagfunc=lsp#lsp#TagFunc
  }
  autocmd User LspProgressUpdate redrawstatus
  autocmd BufWritePre * silent! LspFormat
augroup END

nnoremap <silent> <nowait> gd <Cmd>LspGotoDefinition<CR>
nnoremap <silent> <nowait> gy <Cmd>LspGotoTypeDef<CR>
nnoremap <silent> <nowait> gi <Cmd>LspGotoImpl<CR>
nnoremap <silent> <nowait> gr <Cmd>LspShowReferences<CR>

# Show documentation for the symbol under the cursor
nnoremap <silent> K <Cmd>LspHover<CR>

# Navigate diagnostics
nnoremap <silent> <nowait> [g <Cmd>LspDiag prev<CR>
nnoremap <silent> <nowait> ]g <Cmd>LspDiag next<CR>

# Symbol rename
nnoremap <silent> <leader>rns <Cmd>LspRename<CR>

# Code actions
nnoremap <silent> <leader>a  <Cmd>LspCodeAction<CR>
xnoremap <silent> <leader>a  :LspCodeAction<CR>
nnoremap <silent> <leader>ac <Cmd>LspCodeAction<CR>
nnoremap <silent> <leader>as <Cmd>LspCodeAction only:source<CR>

# Apply the preferred quickfix on the current line
nnoremap <silent> <leader>qf <Cmd>LspFixAll<CR>

# Refactor code actions
nnoremap <silent> <leader>re <Cmd>LspCodeAction kind:refactor<CR>
nnoremap <silent> <leader>r  <Cmd>LspCodeAction kind:refactor<CR>
xnoremap <silent> <leader>r  :LspCodeAction kind:refactor<CR>

# Expand/shrink selection by symbol range
nnoremap <silent> <C-s> <Cmd>LspSelectionExpand<CR>
xnoremap <silent> <C-s> :<C-u>LspSelectionExpand<CR>

# Copy hover/type definition into the system clipboard
nnoremap <silent> <leader>ccd <Cmd>call g:LspCopyDefinition()<CR>

# :Format wrapper to keep the old muscle memory
command! -nargs=0 Format LspFormat

inoremap <silent> <C-@> <C-x><C-o>

import autoload 'lsp/buffer.vim' as lspbuf

def g:ToggleTypescriptLsp()
  var ts = lspbuf.CurbufGetServerByName('typescriptlang')
  if ts->empty()
    echo 'typescriptlang not attached to this buffer'
    return
  endif

  var enabled = ts.features->get('completion', true)
  ts.features.completion = !enabled
  ts.features.hover = !enabled
  ts.features.definition = !enabled
  ts.features.references = !enabled
  ts.features.signatureHelp = !enabled

  if enabled
    echom 'TypeScript LSP: OFF — tailwind now provides completion/hover'
  else
    echom 'TypeScript LSP: ON'
  endif
enddef

nnoremap <silent> <leader>ll <Cmd>call g:ToggleTypescriptLsp()<CR>

def g:LspCopyDefinition()
  var orig = g:LspOptionsGet().hoverInPreview
  g:LspOptionsSet({hoverInPreview: true})

  silent! LspHover
  sleep 200m

  var bnr = bufnr('LspHover')
  if bnr == -1
    echoerr "You must be joking..."
    g:LspOptionsSet({hoverInPreview: orig})
    return
  endif

  var content = getbufline(bnr, 1, '$')->join("\n")

  setreg('"', content)
  if has('clipboard')
    setreg('+', content)
  endif

  pclose
  g:LspOptionsSet({hoverInPreview: orig})
  echom "Now put it where it belongs..."
enddef
