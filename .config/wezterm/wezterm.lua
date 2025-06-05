local dark_opacity = 1
local light_opacity = 1

local b = require("utils/background")
local h = require("utils/helpers")
local c = require("utils/color")
local l = require("utils/lume")
local k = require("keymaps")

local wezterm = require("wezterm")
local mux = wezterm.mux
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

local keybind = require("keybinds")

local function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local config = {
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",

	background = {
		b.get_background(dark_opacity, light_opacity),
	},
	font_size = 18,
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
		TERM = "xterm-256color",
		LC_ALL = "en_US.UTF-8",
	},

	-- general options
	enable_tab_bar = true, -- disable tabbar we need to use tmux
	tab_bar_at_bottom = true,
	debug_key_events = false,
	use_fancy_tab_bar = false,
	native_macos_fullscreen_mode = false,
	-- window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 900,
	adjust_window_size_when_changing_font_size = false,
        max_fps = 120,

	-- Keymaps
	disable_default_key_bindings = true,
	keys = keybind.keys,
	key_tables = keybind.key_tables,
	leader = { key = "s", mods = "CMD|CTRL", timeout_milliseconds = 1000 },
}

if is_windows then
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "WSL",
			default_cwd = "/home/mjjuan",
		},
	}
	config.default_domain = "WSL:NixOS"
else
	config.unix_domains = {
		{
			name = "unix",
		},
	}
	config.default_gui_startup_args = { "connect", "unix" }
	config.default_domain = "unix"
	config.default_mux_server_domain = "unix"
end

-- plugins
local t = require("plugins.tabbar")
local s = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
--
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

local function is_default_startup(cmd)
	if not cmd then
		return true
	end
	if cmd.domain == "DefaultDomain" and not cmd.args then
		return true
	end
	return false
end

wezterm.on("gui-startup", function(cmd)
	if is_default_startup(cmd) then
		-- for the default startup case, we want to switch to the unix domain instead
		local unix = mux.get_domain("unix")
		mux.set_default_domain(unix)
		-- ensure that it is attached
		unix:attach()
	end
end)

return config
