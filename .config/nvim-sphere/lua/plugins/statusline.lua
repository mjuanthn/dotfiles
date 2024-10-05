return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = false,
        theme = "auto",
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        -- lualine_a = {},
        -- lualine_b = {},
        -- lualine_c = {}, -- group_filename,
        -- lualine_x = {}, -- group_branch,
        -- lualine_y = { "fancy_diagnostics" },
        -- lualine_z = {},
      },
      inactive_sections = {
        -- lualine_a = {},
        -- lualine_b = {},
        -- lualine_c = {}, -- { fileicon, filename },
        -- lualine_x = {},
        -- lualine_y = {},
        -- lualine_z = {},
      },
      inactive_winbar = {
        lualine_c = {
          "%=",
          {
            "filename",
            path = 1,
            symbols = { modified = "", readonly = "", new = "", unnamed = "" },
          },
        },
      },
      winbar = {
        lualine_a = {},
        lualine_b = {
          {
            "filename",
            path = 0,
            file_status = false,
          },
        },
        lualine_c = {
          "%=",
          {
            "filename",
            path = 1,
            file_status = false,
          },
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
          },
          -- {
          --   "filetype",
          --   icon_only = true,
          -- },
        },
        lualine_y = {
          "fancy_diagnostics",
          {
            "diff",
          },
          "fancy_branch",
          {
            --"fancy_diagnostics",
          },
        },
        lualine_z = {},
      },
      extensions = {}
    })
  end,
}
