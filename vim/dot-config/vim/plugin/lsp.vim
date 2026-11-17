vim9script

# Thin loader. The real configuration lives in autoload/lspconf.vim and is
# loaded on demand when the yegappan/lsp plugin fires LspSetup.

autocmd! User LspSetup lspconf#Setup()
