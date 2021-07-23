require'lualine'.setup{
    options = { theme = 'tokyonight' },
    sections = {
        lualine_c = {
            {'filename', path=1},
            {
                'diagnostics',
                sources = {'nvim_lsp'}
            }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype', 'branch','diff'}
    }
}

-- Python LSP Configuration
require'lspconfig'.pyright.setup{
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "off"
            }
        }
    }
}


require'lspconfig'.rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    },
    --capabilities = capabilities,
})

require "lsp_signature".setup()

-- Treesitter config
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "rust"},     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", },  -- list of language that will be disabled
  },
}

-- Iron.nvim config
local iron = require('iron')

iron.core.set_config {
  preferred = {
    python = "ipython"
  }
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}
