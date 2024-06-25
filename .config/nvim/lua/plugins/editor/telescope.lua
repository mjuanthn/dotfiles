local icons = require("config.ui.icons")
local actions = require("telescope.actions")
local trouble = require("trouble.sources.telescope")

require("telescope").load_extension("harpoon")

return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {},
    },
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      {
        "<leader>fW",
        '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<CR>',
        desc = "Grep Buffers",
      },
      { "<leader>fB", "<cmd>Telescope git_branches<cr>", desc = "Checkout Branch" },
      { "<leader>sP", "<cmd>Telescope harpoon marks<cr>", desc = "Harpoon Marks" },
    },
    opts = {
      defaults = {
        prompt_prefix = icons.ui.Search .. " ",
        selection_caret = " " .. icons.ui.BoldArrowRight .. " ",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<esc>"] = actions.close,
          ["<C-Esc>"] = actions.close,
          ["<C-q>"] = trouble.open,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
          ["<C-q>"] = trouble.open,
        },
      },
      pickers = {
        live_grep = {},
        grep_string = {},
        find_files = { previewer = true },
        buffers = {
          initial_mode = "normal",
          previewer = false,
          sort_lastused = true,
          sort_mru = true,
          layout_config = {
            width = 0.6,
            height = 0.3,
          },
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
            n = {
              ["dd"] = actions.delete_buffer,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
        lsp_references = { initial_mode = "normal" },
        lsp_definitions = { initial_mode = "normal" },
        lsp_declarations = { initial_mode = "normal" },
        lsp_implementations = { initial_mode = "normal" },
      },
    },
  },
  {
    "m-demare/hlargs.nvim",
    event = "LspAttach",
    opts = {},
  },
}
