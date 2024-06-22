local M = {}
local h = require("utils/helpers")

--- M.get_background
-- @param dark (int) Represents the darkness level of the background.
-- @param light (int) Represents the lightness level of the background.
-- @return The computed background color.
M.get_background = function(dark, light)
	dark = dark or 0.8
	light = light or 0.8
	return {
		source = {
			Gradient = {
				colors = { "#1C1E20" },
				-- colors = { h.is_dark() and "#1C1E20" or "#ffffff" },
				-- colors = { h.is_dark() and "#1A1D1E" or "#ffffff" },
			},
		},
		width = "100%",
		height = "100%",
		opacity = h.is_dark() and dark or light,
	}
end

return M
