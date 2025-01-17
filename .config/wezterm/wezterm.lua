local dark_opacity = 1
local light_opacity = 1

local b = require("utils/background")
local h = require("utils/helpers")
local c = require("utils/color")
-- local f = require("utils/font")
local k = require("keymaps")
local wezterm = require("wezterm")

local keybind = require("keybinds")

local config = {
	background = {
		b.get_background(dark_opacity, light_opacity),
	},
	font_size = 16,
	line_height = 1.1,
	font = wezterm.font_with_fallback({
		"Berkeley Mono",
		{ family = "JetBrainsMono Nerd Font", weight = "Regular", scale = 1.2 },
	}),

	color_scheme = "Mocha (base16)",

	window_padding = {
		left = 8,
		right = 8,
		top = 8,
		bottom = 0,
	},

	set_environment_variables = {
		BAT_THEME = h.is_dark() and "Catppuccin-mocha" or "Catppuccin-latte",
		TERM = "xterm-256color",
		LC_ALL = "en_US.UTF-8",
	},

	-- general options
	enable_tab_bar = true, -- disable tabbar we need to use tmux
	tab_bar_at_bottom = true,
	debug_key_events = false,
	use_fancy_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 900,
	-- Keymaps
	disable_default_key_bindings = true,
	keys = keybind.keys,
	key_tables = keybind.key_tables,
	leader = { key = ",", mods = "CTRL", timeout_milliseconds = 2000 },
}

-- plugins
local t = require("plugins.tabbar")
local s = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- apply config
k.apply_to_config(config) -- keymaps
c.apply_to_config(config) -- colors
t.apply_to_config(config) -- tabbar
s.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return config
