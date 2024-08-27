local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local k = require("utils/keys")
local workspace = require("plugins/workspace")
local home = "/Users/mjuan"

local function isViProcess(pane)
	-- get_foreground_process_name On Linux, macOS and Windows,
	-- the process can be queried to determine this path. Other operating systems
	-- (notably, FreeBSD and other unix systems) are not currently supported
	return pane:get_foreground_process_name():find("n?vim") ~= nil
	-- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(wezterm.action.SendKey({ key = "w", mods = "CTRL" }), pane)
		window:perform_action(wezterm.action.SendKey({ key = vim_direction }), pane)
	else
		window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
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

wezterm.on("workspace-open", function()
	local tab, pane, window = mux.spawn_window({})
	local left_pane = pane:split({ direction = "Left" })
	left_pane:split({ direction = "Bottom " })
	pane:activate()
end)

return {
	{
		key = "G",
		mods = "CMD|SHIFT",
		action = wezterm.action({
			SpawnCommandInNewTab = {
				args = { "lazygit" },
				set_environment_variables = {
					PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
					XDG_CONFIG_HOME = string.format("%s/%s", home, ".config"),
				},
			},
		}),
	},

	{
		key = "O",
		mods = "CMD|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			-- Create a new workspace
			window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = "new-workspace",
				}),
				pane
			)

			-- Split the current pane horizontally to create the left and right sections
			window:perform_action(wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)

			-- Focus the newly created right pane
			window:perform_action(wezterm.action.ActivatePaneDirection("Right"), pane)

			-- Split the right pane vertically to create two stacked panes
			window:perform_action(wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }), pane)

			-- Focus the bottom-right pane
			window:perform_action(wezterm.action.ActivatePaneDirection("Down"), pane)
		end),
	},
	-- {
	-- 	key = "O",
	-- 	mods = "CMD|SHIFT",
	-- 	action = require("wez-per-project-workspace.plugin").action.ProjectWorkspaceSelect({
	-- 		base_dirs = {
	-- 			{
	-- 				path = wezterm.home_dir .. "/projects",
	-- 				min_depth = 1,
	-- 				max_depth = 2,
	-- 			},
	-- 		},
	-- 		rooters = { ".git" },
	-- 		shorten_paths = true,
	-- 	}),
	-- },

	-- Change workspace
	-- {
	-- 	key = "L",
	-- 	mods = "CMD|SHIFT",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		local last = wezterm.GLOBAL.last_open_workspace
	-- 		wezterm.GLOBAL.last_open_workspace = window:active_workspace()
	-- 		window:perform_action(wezterm.action.SwitchToWorkspace({ name = last }), pane)
	-- 	end),
	-- },
	-- {
	-- 	key = "m",
	-- 	mods = "LEADER|CTRL",
	-- 	action = wezterm.action({
	-- 		SpawnCommandInNewTab = {
	-- 			args = { "lazygit" },
	-- 			set_environment_variables = {
	-- 				PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
	-- 				XDG_CONFIG_HOME = string.format("%s/%s", home, ".config"),
	-- 			},
	-- 		},
	-- 	}),
	-- },

	-- {
	-- 	key = "S",
	-- 	mods = "CTRL|SHIFT",
	-- 	action = wezterm.action_callback(function(window, pane)
	-- 		-- Here you can dynamically construct a longer list if needed
	--
	-- 		local home = wezterm.home_dir
	-- 		local workspaces = {
	-- 			{ id = home, label = "Home" },
	-- 			{ id = home .. "/projects/nostromo-front", label = "Nostromo" },
	-- 			{ id = home .. "/projects/personalization-components", label = "PComponents" },
	-- 			{ id = home .. "/dotfiles", label = "Dotfiles" },
	-- 		}
	--
	-- 		window:perform_action(
	-- 			act.InputSelector({
	-- 				action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
	-- 					if not id and not label then
	-- 						wezterm.log_info("cancelled")
	-- 					else
	-- 						wezterm.log_info("id = " .. id)
	-- 						wezterm.log_info("label = " .. label)
	-- 						inner_window:perform_action(
	-- 							act.SwitchToWorkspace({
	-- 								name = label,
	-- 								spawn = {
	-- 									label = "Workspace: " .. label,
	-- 									cwd = id,
	-- 								},
	-- 							}),
	-- 							inner_pane
	-- 						)
	-- 					end
	-- 				end),
	-- 				title = "Choose Workspace",
	-- 				choices = workspaces,
	-- 				fuzzy = true,
	-- 				fuzzy_description = "Fuzzy find and/or make a workspace",
	-- 			}),
	-- 			pane
	-- 		)
	-- 	end),
	-- },

	-- New workspace (prompt name)
	{
		key = "N",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = "#E6CD9A" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	-- {
	-- 	key = "k",
	-- 	mods = "CMD",
	-- 	action = act.ShowLauncherArgs({
	-- 		flags = "FUZZY|WORKSPACES",
	-- 	}),
	-- },
}
