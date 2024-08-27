local icons = require 'config.icons'

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = icons.ui.DashedLine },
      change = { text = icons.ui.DashedLine },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = icons.ui.DashedLine },
      untracked = { text = icons.ui.DashedLine },
    },
  },
}
