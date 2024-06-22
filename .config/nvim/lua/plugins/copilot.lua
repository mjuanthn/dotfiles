return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        -- suggestion = { enabled = false },
        -- panel = { enabled = false },
        panel = {
          enabled = true,
          auto_refresh = true,
          -- keymap = {
          -- 	jump_next = "<c-j>",
          -- 	jump_prev = "<c-k>",
          -- 	accept = "<CR>",
          -- 	refresh = "r",
          -- 	open = "<leader>C",
          -- },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          -- keymap = {
          -- 	--clear suggestion
          -- 	accept = "<M-a>",
          accept_word = false,
          accept_line = false,
          -- next = "<M-j>",
          -- prev = "<M-k>",
          -- 	dismiss = "<C-e>",
          -- },
        },
      }
    end,
  },
  -- {
  -- 	"zbirenbaum/copilot-cmp",
  -- 	config = function()
  -- 		require("copilot_cmp").setup()
  -- 	end,
  -- },
}
