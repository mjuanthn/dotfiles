local wezterm = require("wezterm")
local act = wezterm.action
local k = require("utils/keys")
local h = require("utils/helpers")

wezterm.on("FindCommand-p", function(window, pane)
	--wezterm.log_warn(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope find_files"),
		act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		})
	)
end)

wezterm.on("FindCommand-shift-f", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope live_grep"),
		k.multiple_actions(":Telescope live_grep")
	)
end)

wezterm.on("FindCommand-f", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case"),
		k.multiple_actions(":Telescope live_grep")
	)
end)

-- ShowFileTree
wezterm.on("ShowFileTree", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		act.Multiple({
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":Neotree float reveal toggle"),
		}),
		nil
	)
end)

-- Save all changes
wezterm.on("EditorSaveAll", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		act.Multiple({
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":wa"),
		}),
		nil
	)
end)

-- Save all changes
wezterm.on("EditorSaveAllAndQuit", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		act.Multiple({
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":qa"),
		}),
		nil
	)
end)

return {
	{ key = "0", mods = "CMD", action = act.ActivateCommandPalette },
	{
		key = "l",
		mods = "CMD",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},

	-- VIM commands
	{ key = "p", mods = "CMD", action = wezterm.action.EmitEvent("FindCommand-p") },
	{ key = "f", mods = "CMD", action = wezterm.action.EmitEvent("FindCommand-f") },
	{ key = "F", mods = "CMD", action = wezterm.action.EmitEvent("FindCommand-shift-f") },
	{ key = "s", mods = "CMD", action = wezterm.action.EmitEvent("EditorSaveAll") },
	{ key = "q", mods = "CMD", action = wezterm.action.EmitEvent("EditorSaveAllAndQuit") },
	{ key = "e", mods = "CMD", action = wezterm.action.EmitEvent("ShowFileTree") },
	{
		key = "W",
		mods = "CMD|SHIFT",
		action = act.Multiple({
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":bufdo bd"),
		}),
	},
	{
		key = "s",
		mods = "CMD",
		action = act.Multiple({
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":wa"),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
		}),
	},
	{
		key = "k",
		mods = "CMD",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}
