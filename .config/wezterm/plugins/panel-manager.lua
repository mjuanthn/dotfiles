local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local k = require("utils/keys")

local M = {}

local termEditors = { "hx", "nvim", "vim" }
local winExt = ".exe" -- extension to add to match Windows process names

local function isEditor(name)
	if type(name) ~= "string" then
		return nil
	end
	wezterm.log_info("@isEditor,name=" .. name)
	for _, editor in pairs(termEditors) do
		if name == editor then
			return true
		end
		if name == editor .. winExt then
			return true
		end
	end
	return false
end

local function stdBasename(path)
	local isWin = wezterm.target_triple == "x86_64-pc-windows-msvc"
	if type(path) ~= "string" then
		return nil
	end
	if isWin then
		return path:gsub("(.*[/\\])(.*)", "%2")
	else
		return path:gsub("(.*/)(.*)", "%2")
	end
end

local function isViProcess(pane)
	local procName = stdBasename(pane:get_foreground_process_name())
	return isEditor(procName)
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

local function conditionalExecuteAction(window, pane, action_editor, action_native)
	if isViProcess(pane) then
		window:perform_action(action_editor, pane)
	else
		window:perform_action(action_native, pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

wezterm.on("KillEditorPanel", function(window, pane)
	conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":q!"),
		wezterm.action.CloseCurrentPane({ confirm = false })
	)
end)

wezterm.on("CloseCurrentPanel", function(window, pane)
	conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":bd"),
		wezterm.action.CloseCurrentPane({ confirm = false })
	)
end)

wezterm.on("EditorFindCommand-p", function(window, pane)
	conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope find_files"),
		wezterm.action.ActivateCommandPalette
	)
end)

wezterm.on("EditorFindCommand-f", function(window, pane)
	conditionalExecuteAction(
		window,
		pane,
		k.multiple_actions(":Telescope live_grep"),
		wezterm.action.Search({ CaseSensitiveString = "" })
	)
end)

M.apply_to_config = function(config)
	config.unix_domains = { { name = "unix" } }
	local new_keys = {
		{ key = "P", mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },
		{ key = "h", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
		{ key = "j", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
		{ key = "k", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
		{ key = "l", mods = "CTRL", action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
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

		-- Panels: resize
		{
			key = "H",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Left", 5 }),
		},
		{
			key = "J",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Down", 5 }),
		},
		{ key = "K", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{
			key = "L",
			mods = "CTRL|SHIFT",
			action = act.AdjustPaneSize({ "Right", 5 }),
		},

		-- Panels: movek.cmd_key("p",
		{
			key = "h",
			mods = "CTRL",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "CTRL",
			action = act.ActivatePaneDirection("Down"),
		},
		{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
		{
			key = "l",
			mods = "CTRL",
			action = act.ActivatePaneDirection("Right"),
		},

		-- NVIM commands
		{ key = "p", mods = "CMD", action = wezterm.action.EmitEvent("EditorFindCommand-p") },
		{ key = "f", mods = "CMD", action = wezterm.action.EmitEvent("EditorFindCommand-f") },
		{ key = "q", mods = "CMD", action = wezterm.action.EmitEvent("KillEditorPanel") },
		{ key = "w", mods = "CMD", action = wezterm.action.EmitEvent("CloseCurrentPanel") },
	}

	for _, key in ipairs(new_keys) do
		table.insert(config.keys, key)
	end
end

return M
