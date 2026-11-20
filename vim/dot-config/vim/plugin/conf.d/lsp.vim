vim9script

import autoload 'lsp/buffer.vim'
import autoload 'lsp/lsp.vim'
import autoload 'lsp/util.vim'

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

# def g:LspEchoAttached()
#   var ctx = get(g:, 'LspAttachedContext', {})
#   echom $'Attached {ctx->get("file", "")} ' .. $'(buf {ctx->get("bufnr", -1)})'
#   g:LspLinkLogs()
# enddef

const LogDir = expand('~/.sandbox/AHMET_IKIZ')

export def LspLinkLogs()
        if !isdirectory(LogDir)
                mkdir(LogDir, 'p')
        endif
        for src in glob('/tmp/lsp-*.log', 0, 1) + glob('/tmp/lsp-*.err', 0, 1)
                + glob('/tmp/tsserver*.log', 0, 1)
                system('ln -sf ' .. shellescape(src) .. ' '
                        .. shellescape(LogDir .. '/' .. fnamemodify(src, ':t')))
        endfor
enddef

# Fix-all on save.  oxlint does not answer "only:source.fixAll" code action
# requests (it only reacts to "source.fixAll.oxc"), so use the same
# workspace/executeCommand "oxc.fixAll" command coc-oxc used.  The server
# applies the resulting edits with a workspace/applyEdit request, which the
# plugin handles.  Falls back to :LspFixAll for any other server.
export def LspSaveFixAll()
        if !g:LspServerReady()
                return
        endif
        for lspserver in buffer.CurbufGetServers()
                if lspserver.name == 'oxlint'
                        lspserver.rpc('workspace/executeCommand', {
                                command: 'oxc.fixAll',
                                arguments: [{uri: util.LspFileToUri(@%)}],
                        })
                        return
                endif
        endfor
        silent! LspFixAll
enddef

export def LspSaveFormat()
        if g:LspServerReady()
                silent! LspFormat
        endif
enddef

export def LspProfStart()
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

export def LspProfStop()
        execute 'profile stop'
        g:LspLinkLogs()
        echom 'Profile written to /tmp/lsp-prof-*.txt'
enddef

# An autocmd "{ ... }" block cannot contain a line starting with "}" (it would
# end the block), so the setup runs from this function instead.
def LspSetup()
        g:LspOptionsSet({
                autoHighlightDiags: true,
                popupBorderCompletion: true,
                omniComplete: true,
                omniCompleteAllowBare: true,
                # Matching + ordering of the completion menu:
                #   'case'  - prefix match, case sensitive (plugin default)
                #   'icase' - prefix match, ignore case
                #   'fuzzy' - fuzzy match; NOTE: skips the sortText sort, so the menu
                #             order is whatever raw order the server returned
                # 'icase' keeps the server's own ranking (sortText) and drops loosely
                # related fuzzy hits.
                completionMatcher: 'icase',
                # Query every attached server that supports completion and merge
                # the results (typescript-language-server + tailwindcss).
                completionFromAllServers: true,
                # Only servers that explicitly set features.completion = true
                # are queried.  oxlint/oxfmt are not.
                completionRequireOptIn: true,
                ignoreCompleteItemsIsIncomplete: ['vimls-go'],
                filterCompletionDuplicates: true,
                noNewlineInCompletion: true,
                incrementalSync: true,
                # Makes the completionKinds map below actually apply (default: single
                # letters like t/m/f/k in the kind column).
                customCompletionKinds: true,
                # Apply the LSP server's extra text edits after accepting a completion
                # (auto-imports etc.).
                completionTextEdit: true,
                # Docs in the preview window instead of a popup next to the menu.
                # completionInPreview: true,
                # Moves labelDetails/detail out of the menu row into the info popup.
                condensedCompletionMenu: false,
                showSignatureDocs: true,
                # Snippet expansion is off unless you enable a snippet plugin
                # (vsnipSupport / ultisnipsSupport / snippetSupport).
                ultisnipsSupport: true,
                snippetSupport: true,
                completionKinds: {
                        Text: '󰉿 txt',
                        Method: '󰆧 meth',
                        Function: '󰊕 fn',
                        Constructor: ' ctor',
                        Field: '󰜢 fld',
                        Variable: '󰀫 var',
                        Class: '󰠱 class',
                        Interface: ' intf',
                        Module: ' mod',
                        Property: '󰜢 prop',
                        Unit: '󰑭 unit',
                        Value: '󰎠 val',
                        Enum: ' enum',
                        Keyword: '󰌋 kw',
                        Snippet: ' snip',
                        Color: '󰏘 color',
                        File: '󰈙 file',
                        Reference: '󰈇 ref',
                        Folder: '󰉋 dir',
                        EnumMember: ' enm',
                        Constant: '󰏿 const',
                        Struct: '󰙅 struct',
                        Event: ' event',
                        Operator: '󰆕 op',
                        TypeParameter: '󰊄 type',
                        Buffer: '󰈔 buf'
                },
                showDiagInPopup: true,
                showDiagOnStatusLine: true,
                popupBorder: true,
        })

        g:LspAddServer([
                {
                        name: 'vimls-go',
                        filetype: ['vim'],
                        path: 'vimls',
                        args: [],
                        debug: true,
                        features: {
                                completion: true
                        },
                        initializationOptions: {
                                runtimepath: globpath(&runtimepath, '', 0, 1),
                                # ->filter((_, p) => p !~# '/pack/plugins/start/' || p =~# '/lsp/\?$'),
                                vimVersion: VimVersion(),
                        },
                        syncInit: true,
                        processDiagHandler: (diags: list<dict<any>>) => {
                                # echom diags 
                                return diags->map((ix, diag) => {
                                        var new = diag
                                        new.message = diag.source .. ' - ' .. diag.message
                                        return new
                                })
                        },
                },
                {
                        name: 'typescript-language-server',
                        filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
                        path: 'typescript-language-server',
                        args: ['--stdio'],
                        syncInit: true,
                        features: {
                                documentFormatting: false,
                                documentRangeFormatting: false,
                                completion: true
                        },
                        initializationOptions: {
                                preferences: {
                                        includeCompletionsForModuleExports: true,
                                        includeCompletionsForImportStatements: true,
                                        includeCompletionsWithInsertText: true,
                                        includeAutomaticOptionalChainCompletions: true,
                                        useLabelDetailsInCompletionEntries: true,
                                        updateImportsOnFileSave: true,
                                        importModuleSpecifier: 'non-relative',
                                        quotePreference: 'single',
                                },
                        },
                        processDiagHandler: (diags: list<dict<any>>) => {
                                # echom diags 
                return diags->map((ix, diag) => {
                        var new = diag
                        new.message = diag.source .. ' - ' .. diag.message
                        return new
                                })
                        },
                },
                {
                        name: 'vscode-json-server',
                        filetype: ['json'],
                        path: 'vscode-json-language-server',
                        args: ['--stdio'],
                        syncInit: true,
                        features: {
                                completion: true
                        },
                },
                {
                        
                        name: 'tailwindcss',
                        filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
                        path: 'tailwindcss-language-server',
                        args: ['--stdio'],
                        syncInit: true,
                        debug: true,
                        features: {
                                completion: true 
                        }
                }
        ])
enddef

aug _lsp_conf
        au!
        au User LspSetup LspSetup()
aug END

# ---------------------------------------------------------------------------
# oxlint / oxfmt (migrated from coc-oxc)
#
# Both are registered lazily on the first JavaScript/TypeScript buffer, and
# only when a binary can be found.  Resolution order (same as coc-oxc):
#   1. g:LspOxlintBinPath / g:LspOxfmtBinPath
#   2. "<root>/node_modules/vite-plus/bin/vp" or "<root>/node_modules/.bin/vp",
#      started as: node <vp> lint|fmt --lsp
#   3. "<root>/node_modules/.bin/oxlint" / "oxfmt", started with --lsp
#   4. a global "oxlint" / "oxfmt" (or "vp") on the PATH
#
# The workspace root is resolved once per session, like coc's workspace.root:
# the nearest directory containing a repo-level marker (.git, .hg,
# pnpm-workspace.yaml), falling back to the startup directory.  Deliberately
# NOT "package.json"/"node_modules": in a monorepo those match the nearest
# package, so the oxlint worker would be rooted at a single package and files
# in the other packages would never match a worker (no diagnostics).  One
# repo-level root means one worker covering the whole repo.
#
# Servers are registered once per session (the plugin keeps one server per
# file type), so the first project opened wins.
#
# Settings reach the servers through workspace/configuration, which the
# servers request after initialization (section "oxc_language_server").
#
# The server process inherits Vim's environment (coc-oxc passed process.env
# explicitly); RUST_LOG is added in front of the command like coc-oxc did.
# ---------------------------------------------------------------------------

# oxlint also handles vue/svelte/astro if you want it to; oxfmt additionally
# formats json/yaml/markdown/css/html and more -- add those file types to
# OxfmtFiletypes if you want oxfmt to take them over.
const OxLintFiletypes = ['javascript', 'typescript', 'javascriptreact', 'typescriptreact']
const OxfmtFiletypes = ['javascript', 'typescript', 'javascriptreact', 'typescriptreact']

# ".git" (no slash) covers git worktrees where .git is a file, not a directory
const OxRootMarkers = ['.git/', '.git', '.hg/', 'pnpm-workspace.yaml']

# Set to true to format with oxfmt and/or run oxlint fix-all on BufWritePre
# (coc-oxc's formatOnSave / codeActionsOnSave).
g:LspOxFormatOnSave = get(g:, 'LspOxFormatOnSave', false)
g:LspOxFixOnSave = get(g:, 'LspOxFixOnSave', false)

# Extra workspace options, e.g.:
# g:LspOxlintOptions = {configPath: '.oxlintrc.json', typeAware: true, fixKind: 'all'}
# g:LspOxfmtOptions = {'fmt.experimental': true}
g:LspOxlintOptions = get(g:, 'LspOxlintOptions', {})
g:LspOxfmtOptions = get(g:, 'LspOxfmtOptions', {})

var OxLintRegistered = false
var OxFmtRegistered = false

def OxFindRoot(startDir: string): string
        var dir: string = startDir->fnamemodify(':p')
        while dir != '' && dir != '/'
                if isdirectory(dir .. '/.git') || filereadable(dir .. '/.git')
                        || isdirectory(dir .. '/.hg')
                        || filereadable(dir .. '/pnpm-workspace.yaml')
                        return dir
                endif
                var parent: string = dir->fnamemodify(':h')
                if parent == dir
                        break
                endif
                dir = parent
        endwhile
        return ''
enddef

def OxVpCmd(vp: string, subcmd: string): dict<any>
        # "vp" is a node script; run it through node like coc-oxc did
        if executable('node')
                return {path: 'node', args: [vp, subcmd, '--lsp']}
        endif
        return {path: vp, args: [subcmd, '--lsp']}
enddef

def OxResolveCmd(name: string, root: string): dict<any>
        var subcmd: string = name == 'oxlint' ? 'lint' : 'fmt'
        var bin: string = get(g:, name == 'oxlint' ? 'LspOxlintBinPath' : 'LspOxfmtBinPath', '')
        if bin != ''
                bin = bin->expand()
                if executable(bin)
                        return {path: bin, args: ['--lsp']}
                endif
        endif
        if root != ''
                for vp in [root .. '/node_modules/vite-plus/bin/vp', root .. '/node_modules/.bin/vp']
                        if executable(vp)
                                return OxVpCmd(vp, subcmd)
                        endif
                endfor
                var local: string = root .. '/node_modules/.bin/' .. name
                if executable(local)
                        return {path: local, args: ['--lsp']}
                endif
        endif
        if executable(name)
                return {path: name, args: ['--lsp']}
        endif
        if executable('vp')
                return OxVpCmd('vp', subcmd)
        endif
        return {}
enddef

def OxEnvCmd(cmd: dict<any>): dict<any>
        # coc-oxc passed process.env plus RUST_LOG (default "info").  The
        # yegappan/lsp job inherits Vim's environment, so only RUST_LOG is
        # added here.  Set g:LspOxRustLog = '' to disable.
        var rustLog: string = get(g:, 'LspOxRustLog', '')
        if rustLog == ''
                rustLog = $RUST_LOG != '' ? $RUST_LOG : 'info'
        endif
        if !executable('env')
                return cmd
        endif
        return {path: 'env', args: ['RUST_LOG=' .. rustLog, cmd.path] + cmd.args}
enddef

def OxAddServer(name: string, cmd: dict<any>, root: string)
        var opts: dict<any> = name == 'oxlint' ? g:LspOxlintOptions : g:LspOxfmtOptions
        var server: dict<any> = {
                name: name,
                filetype: name == 'oxlint' ? OxLintFiletypes : OxfmtFiletypes,
                path: cmd.path,
                args: cmd.args,
                # Keep the workspace root in sync with OxFindRoot(): repo-level
                # markers only, so every buffer in the repo resolves the same
                # root and a single worker covers all packages.
                rootSearch: OxRootMarkers,
                workspaceConfig: {oxc_language_server: opts},
                processDiagHandler: (diags: list<dict<any>>) => {
                return diags->map((ix, diag) => {
                        var new = diag
                        new.message = diag.source .. ' - ' .. diag.message
                        return new
                        })
                        # return diags->filter((ix, diag) => {
                        #         return diag.severity <= 2
                        # })
                },
        }
        if name == 'oxfmt'
                # Formatter only; typescript-language-server has formatting
                # disabled so this server is used for :LspFormat.
                server.features = {documentFormatting: true, diagnostics: true}
        endif
        var envCmd: dict<any> = OxEnvCmd({path: cmd.path, args: cmd.args})
        server.path = envCmd.path
        server.args = envCmd.args
        g:LspAddServer([server])
enddef

def g:OxSetup()
        if &buftype != ''
                return
        endif
        # One workspace root per session, like coc's workspace.root: repo root
        # for the current buffer, falling back to the startup directory.
        var root: string = OxFindRoot(@%->fnamemodify(':p:h'))
        if root == ''
                root = OxFindRoot(getcwd())
        endif
        if !OxLintRegistered
                var lintCmd: dict<any> = OxResolveCmd('oxlint', root)
                if !lintCmd->empty()
                        OxAddServer('oxlint', lintCmd, root)
                        OxLintRegistered = true
                endif
        endif
        if !OxFmtRegistered
                var fmtCmd: dict<any> = OxResolveCmd('oxfmt', root)
                if !fmtCmd->empty()
                        OxAddServer('oxfmt', fmtCmd, root)
                        OxFmtRegistered = true
                endif
        endif
enddef

def g:OxOnSave()
        if g:LspOxFormatOnSave
                LspSaveFormat()
        endif
        if g:LspOxFixOnSave
                LspSaveFixAll()
        endif
enddef

# Manual fix-all for the current buffer (oxlint only; other servers fall back
# to :LspFixAll).
command! -nargs=0 -bar LspOxlintFixAll g:OxlintFixAll()

def g:OxlintFixAll()
        LspSaveFixAll()
enddef

# Running oxlint/oxfmt server instances (with a buffer they are attached
# to), deduplicated by name.
def OxRunningServers(): list<dict<any>>
        var servers: list<dict<any>> = []
        var seen: dict<bool> = {}
        # iterate all buffer numbers: attached buffers may be unloaded
        # (e.g. 'hidden' off after switching to another file)
        for bnr in range(1, bufnr('$'))
                for lspserver in buffer.BufLspServersGet(bnr)
                        if lspserver->empty() || !lspserver.running
                                continue
                        endif
                        var name: string = lspserver.name
                        if (name != 'oxlint' && name != 'oxfmt') || seen->has_key(name)
                                continue
                        endif
                        seen[name] = true
                        servers->add({server: lspserver, bnr: bnr})
                endfor
        endfor
        return servers
enddef

# Re-apply g:LspOxlintOptions / g:LspOxfmtOptions (and the binary paths) by
# restarting the oxlint/oxfmt servers.  Mirrors :LspServer restart, but only
# for these two.  A restart is needed: the servers only hot-apply some
# options through workspace/didChangeConfiguration, options like
# rulesCustomization are read when the worker starts.  Config *file* changes
# (.oxlintrc.json & co) don't need this, saving them is enough (see
# OxConfigSaved).
def g:OxReloadConfig()
        var targets: list<dict<any>> = OxRunningServers()
        if targets->empty()
                util.WarnMsg('No running oxlint/oxfmt server')
                return
        endif
        var ftypes: list<string> = OxLintFiletypes + OxfmtFiletypes
        var bufnrs: list<number> = []
        for binfo in getbufinfo()
                if ftypes->index(binfo.bufnr->getbufvar('&filetype')) != -1
                        bufnrs->add(binfo.bufnr)
                        lsp.RemoveFile(binfo.bufnr)
                endif
        endfor
        for item in targets
                var name: string = item.server.name
                var opts: dict<any> = name == 'oxlint' ? g:LspOxlintOptions : g:LspOxfmtOptions
                var root: string = OxFindRoot(item.bnr->bufname()->fnamemodify(':p:h'))
                if root == ''
                        root = OxFindRoot(getcwd())
                endif
                var cmd: dict<any> = OxResolveCmd(name, root)
                if !cmd->empty()
                        var envCmd: dict<any> = OxEnvCmd(cmd)
                        item.server.path = envCmd.path
                        item.server.args = envCmd.args
                endif
                item.server.workspaceConfig = {oxc_language_server: opts}
                if item.server.running
                        item.server.stopServer()
                endif
                item.server.stoppedByUser = false
                item.server.startServer(item.bnr)
        endfor
        for bnr in bufnrs
                lsp.AddFile(bnr)
        endfor
enddef

command! -nargs=0 -bar LspOxReloadConfig g:OxReloadConfig()

# The servers register config-file watchers (client/registerCapability), but
# yegappan/lsp only acknowledges those without actually watching files.  Send
# the workspace/didChangeWatchedFiles notification the watcher would have
# sent, so a saved .oxlintrc.json / .oxfmtrc.json / *config.ts is picked up
# without restarting the servers.
def g:OxConfigSaved(fname: string)
        if fname->empty()
                return
        endif
        var params = {changes: [{uri: util.LspFileToUri(fname), type: 2}]}  # 2 = Changed
        for item in OxRunningServers()
                item.server.sendNotification('workspace/didChangeWatchedFiles', params)
        endfor
enddef

aug _lsp_oxc
        au!
        au FileType javascript,typescript,javascriptreact,typescriptreact g:OxSetup()
        # NOTE: BufWritePre patterns are file patterns, not file types
        au BufWritePre *.js,*.mjs,*.cjs,*.jsx,*.ts,*.mts,*.cts,*.tsx g:OxOnSave()
        # expand('<afile>') must be evaluated in the autocmd itself, it is empty
        # inside the :def function
        au BufWritePost .oxlintrc.json,*.oxlintrc.json,.oxfmtrc.json,*.oxfmtrc.json,oxlint.config.ts,oxfmt.config.ts,vite.config.ts g:OxConfigSaved(expand('<afile>'))
aug END
