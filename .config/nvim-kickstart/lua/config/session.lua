local M = {
	"rmagatti/auto-session",
}

M.config = function()
	require("auto-session").setup({
		log_level = vim.log.levels.ERROR,
		auto_save_enabled = true,
		-- disable neotree
	})
	require("telescope").load_extension("session-lens")
end

return M
