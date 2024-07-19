local wezterm = require("wezterm")
local act = wezterm.action
local k = require("utils/keys")
local h = require("utils/helpers")

wezterm.on("KillEditorPanel", function(window, pane)
	h.conditionalExecuteAction(window, pane, k.multiple_actions(":q!"), wezterm.action.QuitApplication)
end)

wezterm.on("CloseCurrentPanel", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":bd"),
		wezterm.action.CloseCurrentPane({ confirm = false })
	)
end)

wezterm.on("FindCommand-p", function(window, pane)
	--wezterm.log_warn(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope find_files"),
		k.multiple_actions(":Telescope find_files")
	)
end)

wezterm.on("FindCommand-f", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope live_grep"),
		k.multiple_actions(":Telescope live_grep")
	)
end)

-- Save all changes
wezterm.on("EditorSaveAll", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		act.Multiple({
			act.SendKey({ key = "\x1b" }),
			k.multiple_actions(":wa"),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
			act.SendKey({ key = "\x1b" }),
		}),
		nil
	)
end)

return {
	{ key = "\x1b", mods = "CMD", action = wezterm.action.ActivateCommandPalette },

	-- VIM commands
	{ key = "p", mods = "CMD", action = wezterm.action.EmitEvent("FindCommand-p") },
	{ key = "f", mods = "CMD", action = wezterm.action.EmitEvent("FindCommand-f") },
	{ key = "s", mods = "CMD", action = wezterm.action.EmitEvent("EditorSaveAll") },
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
}
