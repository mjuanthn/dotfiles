local M = {}

M.apply_to_config = function(config)
	config.command_palette_font_size = 16.0
	config.command_palette_bg_color = "#1A1C1D"
	config.command_palette_fg_color = "#749A92"
	config.colors = {
		tab_bar = {
			background = "#1D2021",
			inactive_tab_edge = "#181818",
			active_tab = {
				bg_color = "#1D2021",
				fg_color = "#89B2B4",
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#1D2021",
				fg_color = "#3F595E",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab_hover = {
				bg_color = "#181818",
				fg_color = "#89B2B4",
				italic = false,
				intensity = "Normal",
				underline = "None",
				strikethrough = false,
			},
		},
	}
end

return M
