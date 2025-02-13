return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  cmd = "Neotree",
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree float reveal<cr>",
    },
  },
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = {
          ".git",
        },
        never_show = {
          ".DS_Store",
        },
        always_show = {
          ".env",
        },
      },
    },
    window = {
      position = "right",
      mappings = {
        ["s"] = "",
        ["S"] = "",
        ["<C-x>"] = "",
        ["<C-s>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
        ["<C-f>"] = "clear_filter",
        ["g?"] = "show_help",
        ["/"] = "", -- default search down
        ["?"] = "", --default search above
      },
    },
  },
}
