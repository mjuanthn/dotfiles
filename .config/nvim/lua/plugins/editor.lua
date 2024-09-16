return {
  {
    "j-morano/buffer_manager.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local opts = { noremap = true }
      local map = vim.keymap.set
      -- Setup
      require("buffer_manager").setup({
        select_menu_item_commands = {
          v = {
            key = "<C-v>",
            command = "vsplit",
          },
          h = {
            key = "<C-h>",
            command = "split",
          },
        },
        focus_alternate_buffer = true,
        short_file_names = false,
        short_term_names = false,
        loop_nav = true,
        highlight = "Normal:BufferManagerBorder",
        win_extra_options = {
          winhighlight = "Normal:BufferManagerNormal",
        },
      })
      local bmui = require("buffer_manager.ui")
      map({ "t", "n" }, "<leader><leader>", bmui.toggle_quick_menu, opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "┆" },
        change = { text = "┆" },
        delete = { text = "┆" },
        topdelete = { text = "┆" },
        changedelete = { text = "┆" },
      },
    },
  },
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable("npx") then
        vim.g.mkdp_filetypes = { "markdown" }
      end
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = vim.log.levels.ERROR,
        auto_save_enabled = true,
        -- disable neotree
      })
      require("telescope").load_extension("session-lens")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader><leader>", false },
    },
  },
}
