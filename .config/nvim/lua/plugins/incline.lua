-- local function get_diagnostic_label(props)
-- 	local icons = require("config.ui.icons")
-- 	local label = {}
-- 	for severity, icon in pairs(icons.diagnostics) do
-- 		local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
-- 		if n > 0 then
-- 			table.insert(label, { icon .. "" .. n .. " ", group = "DiagnosticSign" .. severity })
-- 		end
-- 	end
-- 	return label
-- end
--
-- local function get_git_diff(props)
-- 	local icons = { removed = "", changed = "", added = "" }
-- 	local labels = {}
-- 	local success, signs = pcall(vim.api.nvim_buf_get_var, props.buf, "gitsigns_status_dict")
-- 	if success then
-- 		for name, icon in pairs(icons) do
-- 			if tonumber(signs[name]) and signs[name] > 0 then
-- 				table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
-- 			end
-- 		end
-- 		return labels
-- 	else
-- 		for name, icon in pairs(icons) do
-- 			if tonumber(signs[name]) and signs[name] > 0 then
-- 				table.insert(labels, { icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
-- 			end
-- 		end
-- 		return labels
-- 	end
-- end
--
return {
	"b0o/incline.nvim",
	enabled = true,
	event = "BufEnter",
	config = function()
		local devicons = require("nvim-web-devicons")
		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = 0 },
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if filename == "" then
					filename = "[No Name]"
				end
				local ft_icon = devicons.get_icon_color(filename)
				local modified = vim.bo[props.buf].modified
				return {
					{ " ", ft_icon, " ", guibg = "#E6CD9A", guifg = "#1D2021" },
					" ",
					{ filename, gui = modified and "bold,italic" or "" },
					" ",
					guibg = "#35312C",
				}
			end,
		})
	end,
}
