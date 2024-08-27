---@diagnostic disable-next-line: unused-local
local icons = require("config.icons")

return {
	"lukas-reineke/indent-blankline.nvim",
	enabled = true,
	main = "ibl",
	config = function()
		require("ibl").setup({
			indent = {
				char = "·",
				tab_char = "·",
			},
			scope = {
				-- enabled = true
				show_start = false,
				show_end = false,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		})
	end,
}
