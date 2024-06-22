local dark_opacity = 1
local light_opacity = 1

local b = require("utils/background")
local cs = require("utils/color_scheme")
local h = require("utils/helpers")
local k = require("utils/keys")

local wezterm = require("wezterm")
local act = wezterm.action

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

	color_scheme = cs.get_color_scheme(),

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
	adjust_window_size_when_changing_font_size = false,
	tab_bar_at_bottom = true,
	debug_key_events = false,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	show_new_tab_button_in_tab_bar = false,
	tab_max_width = 900,

	colors = {
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
	},

	-- keys
	keys = {
		-- Clear console
		k.cmd_key("k", wezterm.action({ ClearScrollback = "ScrollbackAndViewport" })),
		-- Search commands
		k.cmd_key("p", k.multiple_actions(":Telescope find_files")),
		k.cmd_key("f", k.multiple_actions(":Telescope live_grep")),
		k.cmd_key("q", k.multiple_actions(":q!")),
		k.cmd_key("w", k.multiple_actions(":bd")),
		-- keymap({ 'n', 'v' }, '<C-k>', '<C-u>zz')
		-- keymap({ 'n', 'v' }, '<C-j>', '<C-d>zz')
		k.cmd_key("N", wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" })),
		k.cmd_key("n", wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" })),
		k.cmd_key("s", k.multiple_actions(":wa")),

		-- Save and do more nvim cmd
		-- k.cmd_key(
		-- 	"s",
		-- 	act.Multiple({
		-- 		act.SendKey({ key = "\x1b" }), -- escape
		-- 		k.multiple_actions(":lua SaveAndDoMore()"),
		-- 	})
		-- ),
		-- Close current buffer
		k.cmd_key(
			"w",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":bd"),
			})
		),
		{
			key = "W",
			mods = "CMD|SHIFT",
			action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
		},
		{
			key = "r",
			mods = "CMD",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, _, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			key = "M",
			mods = "CMD|SHIFT",
			action = wezterm.action.TogglePaneZoomState,
		},
		{ key = "S", mods = "LEADER", action = wezterm.action({ EmitEvent = "save_session" }) },
		{ key = "L", mods = "LEADER", action = wezterm.action({ EmitEvent = "load_session" }) },
		{ key = "R", mods = "LEADER", action = wezterm.action({ EmitEvent = "restore_session" }) },
		{
			mods = "CTRL",
			key = "j",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "d" }),
				act.SendKey({ key = "z" }),
				act.SendKey({ key = "z" }),
			}),
		},
		{
			mods = "CTRL",
			key = "k",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "u" }),
				act.SendKey({ key = "z" }),
				act.SendKey({ key = "z" }),
			}),
		},
	},
}

local function readjust_font_size(window, pane)
	local window_dims = window:get_dimensions()
	local pane_dims = pane:get_dimensions()

	local config_overrides = {}
	local initial_font_size = 16 -- Set to your desired font size
	config_overrides.font_size = initial_font_size

	local max_iterations = 5
	local iteration_count = 0
	local tolerance = 3

	-- Calculate the initial difference between window and pane heights
	local current_diff = window_dims.pixel_height - pane_dims.pixel_height
	local min_diff = math.abs(current_diff)
	local best_font_size = initial_font_size

	-- Loop to adjust font size until the difference is within tolerance or max iterations reached
	while current_diff > tolerance and iteration_count < max_iterations do
		-- Increment the font size slightly
		config_overrides.font_size = config_overrides.font_size + 0.5
		window:set_config_overrides(config_overrides)

		-- Update dimensions after changing font size
		window_dims = window:get_dimensions()
		pane_dims = pane:get_dimensions()
		current_diff = window_dims.pixel_height - pane_dims.pixel_height

		-- Check if the current difference is the smallest seen so far
		local abs_diff = math.abs(current_diff)
		if abs_diff < min_diff then
			min_diff = abs_diff
			best_font_size = config_overrides.font_size
		end

		iteration_count = iteration_count + 1
	end

	-- If no acceptable difference was found, set the font size to the best one encountered
	if current_diff > tolerance then
		config_overrides.font_size = best_font_size
		window:set_config_overrides(config_overrides)
	end
end

wezterm.on("window-resized", function(window, pane)
	readjust_font_size(window, pane)
end)

-- Plugins
local bar = require("plugins.wezbar")
bar.apply_to_config(config)

-- session mana
local session_manager = require("plugins/session-manager/session-manager")
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)

-- append following keymap to current config

return config
