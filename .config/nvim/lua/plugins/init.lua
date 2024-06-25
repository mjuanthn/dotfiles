return {
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.support" },

  -- Disabled plugins
  {
    { "lukas-reineke/indent-blankline.nvim", enabled = false },
    { "akinsho/bufferline.nvim", enabled = false },
    { "nvimdev/dashboard-nvim", enabled = false },
  },
}
