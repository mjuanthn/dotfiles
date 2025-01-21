return {
  {
    'ojroques/nvim-bufdel',
    keys = {
      { '<C-w>', ':BufDel<CR>', desc = 'Close current buffer', silent = true },
      { '<C-W>', ':BufDelAll<CR>', desc = 'Close all buffers', silent = true },
    },
    opts = {
      next = 'tabs',
      quit = true, -- quit Neovim when last buffer is closed
    },
  },
  {
    'j-morano/buffer_manager.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader><leader>', ':lua require("buffer_manager.ui").toggle_quick_menu()', desc = 'Show buffer manager', silent = true },
    },
  },
}
