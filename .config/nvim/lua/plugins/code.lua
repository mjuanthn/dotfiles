return {
  -- Syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "tsx",
        "typescript",
        "vue",
        "rust",
        "go",
        "css",
        "scss",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
  },

  -- Language Servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "vue-language-server",
        "eslint_d",
        -- "prettier",
        "tailwindcss-language-server",
        "rust-analyzer",
        "gopls",
        "pyright",
        "typescript-language-server",
        "lua-language-server",
        "css-lsp",
      },
    },
  },

  -- LSPConfig
  {
    "neovim/nvim-lspconfig",
    events = "VeryLazy",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        volar = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "volar" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
      servers = {
        volar = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("package.json", "vue.config.js")(fname)
          end,
        },
      },
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opt = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        typescript = { "eslintd" },
        javascript = { "eslintd" },
        vue = { "eslintd" },
      },
    },
  },

  -- Languages
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway

    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },
  },
}
