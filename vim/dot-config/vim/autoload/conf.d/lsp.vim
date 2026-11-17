vim9script

def SetOptions()
  g:LspOptionsSet({
    autoHighlightDiags: true,
    completionMatcher: 'fuzzy',
    filterCompletionDuplicates: true,
    noNewlineInCompletion: true,
    incrementalSync: true,
    customCompletionKinds: true,
    completionTextEdit: true,
    completionInPreview: true,
    condensedCompletionMenu: true,
    completionKinds: {
      Text: 'txt',
      Method: 'meth',
      Function: 'fn',
      Constructor: 'ctor',
      Field: 'fld',
      Variable: 'var',
      Class: 'class',
      Interface: 'intf',
      Module: 'mod',
      Property: 'prop',
      Unit: 'unit',
      Value: 'val',
      Enum: 'enum',
      Keyword: 'kw',
      Snippet: 'snip',
      Color: 'color',
      File: 'file',
      Reference: 'ref',
      Folder: 'dir',
      EnumMember: 'enm',
      Constant: 'const',
      Struct: 'struct',
      Event: 'event',
      Operator: 'op',
      TypeParameter: 'type',
      Buffer: 'buf'
    },
    showDiagInPopup: true,
    showDiagOnStatusLine: true,
    popupBorder: true,
    popupBorderChars: ['-', '|', '-', '|', '┌', '┐', '┘', '└'],
    popupBorderHighlightHover: 'ModeMsg',
    popupBorderCompletion: true,
    popupHighlightCompletion: 'Pmenu',
    popupBorderHighlightSymbolMenuInput: 'Title',
    popupBorderHighlightSymbolMenu: 'Directory',
    codeActionPopupDetails: 'full',
  })
enddef


def VimVersion(): string
  return exists('v:versionlong')
    ? printf('%d.%d.%04d', v:versionlong / 1000000, (v:versionlong % 1000000) / 10000, v:versionlong % 10000)
    : ''
enddef

# def LspProgressStatus(): string
#     if empty(g:LspProgress)
#         return ''
#     endif
#     for info in values(g:LspProgress)
#         var parts = []
#         if !empty(info.title)
#             parts->add(info.title)
#         endif
#         if info.percentage >= 0
#             parts->add(info.percentage .. '%')
#         endif
#         return parts->join(' ')
#     endfor
#     return ''
# enddef

def AddServers()
  g:LspAddServer([
    {
      name: 'vimls-go',
      filetype: ['vim'],
      path: 'vimls',
      args: [],
      # always log server traffic to /tmp/lsp-vimls-go.log (symlinked into
      # ~/.sandbox/AHMET_IKIZ on attach)
      debug: true,
      traceLevel: 'verbose',
      initializationOptions: {
        runtimepath: globpath(&runtimepath, '', 0, 1),
        vimVersion: VimVersion(),
      },
    },
    {
      name: 'typescript-language-server',
      filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
      path: 'typescript-language-server',
      # args: ['--stdio', '--log-level', '4'],
      args: ['--stdio' ],
      debug: true,
      traceLevel: 'verbose',
      features: { documentFormatting: false, documentRangeFormatting: false },
      initializationOptions: {
        preferences: { importModuleSpecifier: 'non-relative' },
        fileOperations: { willRename: true },
      }
    },
  ])
enddef

def SetMappings()
  nnoremap gd <Cmd>LspGotoDefinition<CR>
  nnoremap gy <Cmd>LspGotoTypeDef<CR>
  nnoremap gi <Cmd>LspGotoImpl<CR>
  nnoremap gr <Cmd>LspShowReferences<CR>

  nnoremap [g <Cmd>LspDiagPrev<CR>
  nnoremap ]g <Cmd>LspDiagNext<CR>

  nnoremap K <Cmd>LspHover<CR>

  nnoremap <leader>rns <Cmd>LspRename<CR>

  nnoremap <leader>a  <Cmd>LspCodeAction<CR>
  xnoremap <leader>a  <Cmd>LspCodeAction<CR>
  nnoremap <leader>qf <Cmd>LspAutoFix<CR>

  inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
  inoremap @ @<Cmd>call lsp#completion#LspComplete(v:true)<CR>
  inoremap <silent> <C-@> <Cmd>call lsp#completion#LspComplete(v:true)<CR>
enddef

def SetAutocmds()
  augroup lspattach
    autocmd!
    autocmd User LspAttached g:LspEchoAttached()
  augroup END

  augroup lspformatonsave
    autocmd!
    autocmd BufWritePre *.{js,jsx,ts,tsx,mjs,mts,cjs} g:LspSaveFixAll()
    autocmd BufWritePre * g:LspSaveFormat()
  augroup END

  augroup lspatrigger
    autocmd!
    autocmd FileType javascript,typescript,javascriptreact,typescriptreact
          \ inoremap <buffer> @ @
  augroup END
enddef

def g:LspEchoAttached()
  var ctx = get(g:, 'LspAttachedContext', {})
  echom $'Attached {ctx->get("file", "")} ' .. $'(buf {ctx->get("bufnr", -1)})'
  g:LspLinkLogs()
enddef

const LogDir = expand('~/.sandbox/AHMET_IKIZ')

def g:LspLinkLogs()
  if !isdirectory(LogDir)
    mkdir(LogDir, 'p')
  endif
  for src in glob('/tmp/lsp-*.log', 0, 1) + glob('/tmp/lsp-*.err', 0, 1)
    + glob('/tmp/tsserver*.log', 0, 1)
    system('ln -sf ' .. shellescape(src) .. ' '
      .. shellescape(LogDir .. '/' .. fnamemodify(src, ':t')))
  endfor
enddef

def g:LspSaveFixAll()
  if g:LspServerReady()
    silent! LspFixAll
  endif
enddef

def g:LspSaveFormat()
  if g:LspServerReady()
    silent! LspFormat
  endif
enddef

def g:LspProfStart()
  var f = $'/tmp/lsp-prof-{strftime("%H%M%S")}.txt'
  execute 'profile start ' .. f
  for name in ['completion.vim', 'diag.vim', 'lspserver.vim', 'lsp.vim',
    'util.vim', 'offset.vim', 'textedit.vim', 'codeaction.vim']
    var p = globpath(&runtimepath, $'autoload/lsp/{name}')
    if p != ''
      execute 'profile! file ' .. p
    endif
  endfor
  echom $'Profiling to {f} — reproduce the lag, then :LspProfStop'
enddef

def g:LspProfStop()
  execute 'profile stop'
  g:LspLinkLogs()
  echom 'Profile written to /tmp/lsp-prof-*.txt'
enddef

export def Setup()
  SetOptions()
  AddServers()
  SetMappings()
  SetAutocmds()
enddef
