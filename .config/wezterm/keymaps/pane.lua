local wezterm = require("wezterm")
local k = require("utils/keys")
local h = require("utils/helpers")

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	h.conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	h.conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	h.conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	h.conditionalActivatePane(window, pane, "Down", "j")
end)

-- Resize pane
wezterm.on("ResizePaneDirection-right", function(window, pane)
	h.conditionalResizePane(window, pane, "Right", "L")
end)
wezterm.on("ResizePaneDirection-left", function(window, pane)
	h.conditionalResizePane(window, pane, "Left", "H")
end)
wezterm.on("ResizePaneDirection-up", function(window, pane)
	h.conditionalResizePane(window, pane, "Up", "K")
end)
wezterm.on("ResizePaneDirection-down", function(window, pane)
	h.conditionalResizePane(window, pane, "Down", "J")
end)

wezterm.on("KillEditorPanel", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":q!"),
		wezterm.action.CloseCurrentPane({ confirm = false })
	)
end)

wezterm.on("CloseCurrentPanel", function(window, pane)
	h.conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":bd"),
		wezterm.action.CloseCurrentPane({ confirm = false })
	)
end)

return {

	-- Navigate
	{ key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },

	-- Resize
	{ key = "H", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ResizePaneDirection-left") },
	{ key = "J", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ResizePaneDirection-down") },
	{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ResizePaneDirection-up") },
	{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("ResizePaneDirection-right") },

	-- Close
	-- k.cmd_key(
	-- 	"w",
	-- 	act.Multiple({
	-- 		act.SendKey({ key = "\x1b" }), -- escape
	-- 		k.multiple_actions(":bd"),
	-- 	})
	-- )

	-- Split
	{
		key = "J",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "L",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Rename current pane
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

	-- Maximize pane
	{
		key = "M",
		mods = "CMD|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
}
