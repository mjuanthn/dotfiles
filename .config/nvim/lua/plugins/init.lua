return {
  -- Utils
  { import = "lazyvim.plugins.extras.linting.eslint" },
  -- { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.coding.yanky" },
  { import = "lazyvim.plugins.extras.coding.codeium" },
  { import = "lazyvim.plugins.extras.coding.neogen" },
  { import = "lazyvim.plugins.extras.editor.refactoring" },
  { import = "lazyvim.plugins.extras.editor.inc-rename" },

  -- Editor
  { import = "lazyvim.plugins.extras.coding.copilot" },
  { import = "lazyvim.plugins.extras.vscode" },

  -- Languages
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.vue" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.go" },

  -- Others
  { import = "lazyvim.plugins.extras.vscode" },

  -- Utils
  {
    -- Better escape
    {
      "max397574/better-escape.nvim",
      config = function()
        require("better_escape").setup()
      end,
    },
    -- Dial - enchanced increment/decrement
    { import = "lazyvim.plugins.extras.editor.dial" },
  },
}
