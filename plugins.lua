-- Start the LSP
require'nvim_lsp'.pyls.setup{on_attach=require'diagnostic'.on_attach}

-- Treesitter config
require'nvim-treesitter.configs'.setup {
  ensure_installed = "python",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}

-- Iron.nvim config
local iron = require('iron')

iron.core.set_config {
  preferred = {
    python = "ipython"
  }
}
