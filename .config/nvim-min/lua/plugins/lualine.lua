local M = {
	"nvim-lualine/lualine.nvim",
	requires = { "kyazdani42/nvim-web-devicons" },
	enabled = true,
	lazy = false,
	priority = 900,
	dependencies = {
		"meuter/lualine-so-fancy.nvim",
	},
}

M.config = function()
	local colors = {
		blue = "#80a0ff",
		cyan = "#8ab3b5",
		black = "#1D2021",
		white = "#c6c6c6",
		red = "#ab6077",
		violet = "#d183e8",
		grey = "#282828",
		green = "#a1b56c",
		grey_soft = "#6a6a6a",

		-- GRUVBOX
		gruvbox_primary = "#E6CD9A",
		gruvbox_secondary = "#35312C",
	}

	local base16_meu = {
		normal = {
			a = { fg = colors.white, bg = colors.cyan },
			b = { fg = colors.gruvbox_primary, bg = colors.gruvbox_secondary },
			c = { fg = colors.white, bg = colors.black },
			x = { fg = colors.white, bg = colors.black },
			y = { fg = colors.gruvbox_primary, bg = colors.gruvbox_secondary },
			z = { fg = colors.white, bg = colors.black },
		},

		insert = { a = { fg = colors.white, bg = colors.green } },
		visual = { a = { fg = colors.white, bg = colors.cyan } },
		replace = { a = { fg = colors.white, bg = colors.red } },

		inactive = {
			a = { fg = colors.grey_soft, bg = colors.black },
			b = { fg = colors.grey_soft, bg = colors.black },
			c = { fg = colors.grey_soft, bg = colors.black },
			x = { fg = colors.grey_soft, bg = colors.black },
			y = { fg = colors.grey_soft, bg = colors.black },
			z = { fg = colors.grey_soft, bg = colors.black },
		},
	}
	local icons = require("config.icons")
	local diff = {
		"diff",
		colored = true,
		symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
	}

	local fileicon = {
		"filetype",
		colored = true, -- Displays filetype icon in color if set to true
		icon_only = true, -- Display only an icon for filetype
		icon = { align = "right" }, -- Display filetype icon on the right hand side
		padding = { left = 1, right = 0 },
	}

	local filename = {
		"filename",
		path = 1,
		file_status = true,
		icons_enabled = true,
		no_name = "",
		symbols = {
			modified = "", -- Text to show when the file is modified.
			readonly = icons.diagnostics.BoldError, -- Text to show when the file is non-modifiable or readonly.
			unnamed = "", -- Text to show for unnamed buffers.
			newfile = "", -- Text to show for newly created file before first write
		},
		padding = { left = 1 },
	}

	local group_filename = {
		fileicon,
		{
			"filename",
			path = 0,
			file_status = false,
			icons_enabled = true,
		},
	}
	local group_filepath = {
		filename,
		"fancy_searchcount",
	}

	require("lualine").setup({
		options = {
			component_separators = { left = "", right = icons.ui.DottedLine .. " " },
			section_separators = { left = "", right = "" },
			ignore_focus = { "NvimTree", "neo-tree" },
			theme = base16_meu,
			icons_enabled = true,
		},
		sections = {
			-- lualine_a = {},
			-- lualine_b = {},
			-- lualine_c = {}, -- group_filename,
			-- lualine_x = {}, -- group_branch,
			-- lualine_y = {},
			-- lualine_z = {},
		},
		inactive_sections = {
			-- lualine_a = {},
			-- lualine_b = {},
			-- lualine_c = {}, -- { fileicon, filename },
			-- lualine_x = {},
			-- lualine_y = {},
			-- lualine_z = {},
		},
		winbar = {
			lualine_b = group_filename,
			lualine_c = group_filepath,
			lualine_x = {
				"fancy_diagnostics",
				diff,
			},
			-- lualine_y = {
			-- 	"fancy_branch",
			-- },
		},
		inactive_winbar = {
			lualine_c = group_filename,
		},
		tabline = {},
		extensions = { "quickfix", "man", "fugitive" },
	})
end

return M
