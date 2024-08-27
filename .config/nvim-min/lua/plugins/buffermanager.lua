return {
	"j-morano/buffer_manager.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local opts = { noremap = true }
		local map = vim.keymap.set
		-- Setup
		require("buffer_manager").setup({
			select_menu_item_commands = {
				v = {
					key = "<C-v>",
					command = "vsplit",
				},
				h = {
					key = "<C-h>",
					command = "split",
				},
			},
			focus_alternate_buffer = true,
			short_file_names = false,
			short_term_names = false,
			loop_nav = true,
			highlight = "Normal:BufferManagerBorder",
			win_extra_options = {
				winhighlight = "Normal:BufferManagerNormal",
			},
		})
		local bmui = require("buffer_manager.ui")
		map({ "t", "n" }, "<leader>bb", bmui.toggle_quick_menu, opts)
	end,
}
