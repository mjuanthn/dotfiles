local os_name = vim.loop.os_uname().sysname
local fzf_build_cmd = "make"

if os_name == "Windows_NT" then
	fzf_build_cmd =
		"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
end

return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = fzf_build_cmd,
			cond = function()
				local build_cmd = os_name == "Windows_NT" and "cmake" or "make"
				return vim.fn.executable(build_cmd) == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local actions = require("telescope.actions")
		local icons = require("config.icons")
		local trouble = require("trouble.sources.telescope")

		require("telescope").setup({
			defaults = {
				prompt_prefix = icons.ui.Search .. " ",
				selection_caret = " " .. icons.ui.BoldArrowRight .. " ",
				entry_prefix = "   ",
				initial_mode = "insert",
				selection_strategy = "reset",
				path_display = { "smart" },
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" },
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/",
				},

				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<esc>"] = actions.close,
						["<C-Esc>"] = actions.close,
						["<C-q>"] = trouble.open_with_trouble,
					},
					n = {
						["<esc>"] = actions.close,
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["q"] = actions.close,
						["<C-q>"] = trouble.open_with_trouble,
					},
				},
			},
			pickers = {
				live_grep = {},
				grep_string = {},
				find_files = { previewer = true },
				buffers = {
					initial_mode = "normal",
					previewer = false,
					sort_lastused = true,
					sort_mru = true,
					layout_config = {
						width = 0.6,
						height = 0.3,
					},
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
						n = {
							["dd"] = actions.delete_buffer,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
				},
				lsp_references = { initial_mode = "normal" },
				lsp_definitions = { initial_mode = "normal" },
				lsp_declarations = { initial_mode = "normal" },
				lsp_implementations = { initial_mode = "normal" },
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		-- vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
		-- vim.keymap.set("n", "<A-p>", builtin.find_files, { desc = "[S]earch [F]iles" })
		-- vim.keymap.set("n", "<A-s>", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<A-f>", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		-- vim.keymap.set("n", "<A-d>", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		-- vim.keymap.set("n", "<A-r>", builtin.resume, { desc = "[S]earch [R]esume" })
		-- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		-- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		-- vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		-- vim.keymap.set("n", "<A-f>", function()
		-- 	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		-- 		previewer = false,
		-- 	}))
		-- end, { desc = "[/] Fuzzily search in current buffer" })
		--
		-- vim.keymap.set("n", "<A-F>", function()
		-- 	builtin.live_grep({
		-- 		grep_open_files = true,
		-- 		prompt_title = "Live Grep in Open Files",
		-- 	})
		-- end, { desc = "[S]earch [/] in Open Files" })
	end,
}
