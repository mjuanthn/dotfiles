return {
	"utilyre/barbecue.nvim",
	name = "barbecue",
	version = "*",
	enabled = false,
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.opt.updatetime = 60000

		require("barbecue").setup({
			create_autocmd = false,
			show_navic = false,
			show_modified = false,
		})

		vim.api.nvim_create_autocmd({
			"WinScrolled",
			"BufWinEnter",
			"CursorHold",
			"InsertLeave",

			-- include this if you have set `show_modified` to `true`
			"BufModifiedSet",
		}, {
			group = vim.api.nvim_create_augroup("barbecue.updater", {}),
			callback = function()
				require("barbecue.ui").update()
			end,
		})
	end,
}
