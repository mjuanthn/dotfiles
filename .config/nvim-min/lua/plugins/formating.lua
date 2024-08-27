return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				typescriptvue = { "eslint_d" },
				javascriptvue = { "eslint_d" },
				vue = { "eslint_d" },
				svelte = { "eslint_d" },
				css = { "stylelint" },
				html = { "stylelint" },
				json = { "jq" },
				yaml = { "eslint_d" },
				markdown = { "eslint_d" },
				graphql = { "eslint_d" },
				liquid = { "eslint_d" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
