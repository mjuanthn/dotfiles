local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

local appearance = wezterm.gui.get_appearance()

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

-- public methods
M.is_dark = function()
	return appearance:find("Dark")
end

M.get_random_entry = function(tbl)
	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

M.conditionalActivatePane = function(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
	end
end

M.conditionalResizePane = function(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL|SHIFT" }), pane)
	else
		window:perform_action(act.AdjustPaneSize({ pane_direction, 5 }), pane)
	end
end

M.conditionalExecuteAction = function(window, pane, action_editor, action_native)
	if isViProcess(pane) then
		if action_editor then
			window:perform_action(action_editor, pane)
		end
	elseif action_native then
		window:perform_action(action_native, pane)
	end
end

M.mergeTables = function(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				M.tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

return M
