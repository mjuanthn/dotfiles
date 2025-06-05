return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "lua",
        "php",
        "python",
        "scss",
        "svelte",
        "tsx",
        "twig",
        "typescript",
        "vim",
        "vue",
      })
    end
  end,
  context_commentstring = {
    enable = true,
  },
}
