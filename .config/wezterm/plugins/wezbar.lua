local wez = require("wezterm")

local config = {
	position = "bottom",
	max_width = 32,
	left_separator = " ",
	right_separator = " ",
	field_separator = "  |  ",
	workspace_icon = "",
	terminal_icon = "",
	pane_icon = "",
	user_icon = "",
	hostname_icon = "󰒋",
	clock_icon = "󰃰",
	cwd_icon = "",
	branch_icon = "",
	enabled_modules = {
		username = false,
		hostname = false,
		clock = false,
		cwd = false,
	},
}

local process_icons = {
	["bash"] = "",
	["zsh"] = "",
	["fish"] = "",
	["vim"] = "",
	["nvim"] = "",
	["node"] = "",
	["cargo"] = "",
	["go"] = "",
	["lazygit"] = "",
	["yazi"] = "",
}

local tab_numbers = {
	"󰎤",
	"󰎧",
	"󰎪",
	"󰎭",
	"󰎱",
	"󰎳",
	"󰎶",
	"󰎹",
	"󰎼",
	"󰎡",
}

local tab_numbers_outline = {
	"󰎦",
	"󰎩",
	"󰎬",
	"󰎮",
	"󰎰",
	"󰎵",
	"󰎸",
	"󰎻",
	"󰎾",
	"󰎣",
}

local username = os.getenv("USER") or os.getenv("LOGNAME") or os.getenv("USERNAME")
local home = (os.getenv("USERPROFILE") or os.getenv("HOME") or wez.home_dir or ""):gsub("\\", "/")
local is_windows = package.config:sub(1, 1) == "\\"

local M = {}

local function get_cwd(tab)
	if not tab.active_pane or not tab.active_pane.current_working_dir then
		return ""
	end

	return tab.active_pane.current_working_dir.file_path or ""
end

local function remove_abs_path(path)
	return path:gsub("(.*[/\\])(.*)", "%2")
end

local function capitalize(str)
	return (str:gsub("^%l", string.upper))
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end

	local current_dir = get_cwd(tab_info)
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
	local folder_name = current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)

	return folder_name
end

local function get_current_process_name(tab_info)
	if tab_info and tab_info.active_pane then
		local process_name = tab_info.active_pane.foreground_process_name
		if process_name then
			-- Convertir a mayúsculas
			return string.upper(process_name)
		end
	end
	return nil
end

local function tableMerge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

local find_git_dir = function(directory)
	directory = directory:gsub("~", home)

	while directory do
		local handle = io.open(directory .. "/.git/HEAD", "r")
		if handle then
			handle:close()
			directory = directory:match("([^/]+)$")
			return directory
		elseif directory == "/" or directory == "" then
			break
		else
			directory = directory:match("(.+)/[^/]*")
		end
	end

	return nil
end

-- Kills a workspace closing all the panels
--
local function kill_wokspace(workspace)
	return function(window, pane, line)
		workspace = workspace or window:get_active_workspace()
		local success, stdout = wez.run_child_process({ "wezterm", "cli", "list", "--format=json" })

		if success then
			local json = wez.json_parse(stdout)
			if not json then
				return
			end

			local workspace_panes = u.filter(json, function(p)
				return p.workspace == workspace
			end)

			for _, p in ipairs(workspace_panes) do
				wez.run_child_process({ "wezterm", "cli", "kill-pane", "--pane-id=" .. p.pane_id })
			end
		end
	end
end

local get_cwd_hostname = function(pane, search_git_root_instead)
	local cwd, hostname, full_path = "", "", ""
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		if type(cwd_uri) == "userdata" then
			-- Running on a newer version of wezterm and we have
			-- a URL object here, making this simple!
			--
			---@diagnostic disable-next-line: undefined-field
			cwd = cwd_uri.file_path
			full_path = cwd_uri.file_path
			---@diagnostic disable-next-line: undefined-field
			hostname = cwd_uri.host or wez.hostname()
		else
			-- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
			-- which doesn't have the Url object
			cwd_uri = cwd_uri:sub(8)
			local slash = cwd_uri:find("/")
			if slash then
				hostname = cwd_uri:sub(1, slash - 1)
				-- and extract the cwd from the uri, decoding %-encoding
				cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
					return string.char(tonumber(hex, 16))
				end)
			end
		end

		-- Remove the domain name portion of the hostname
		local dot = hostname:find("[.]")
		if dot then
			hostname = hostname:sub(1, dot - 1)
		end
		if hostname == "" then
			hostname = wez.hostname()
		end

		if is_windows then
			cwd = cwd:gsub("/" .. home .. "(.-)$", "~%1")
		else
			cwd = cwd:gsub(home .. "(.-)$", "~%1")
		end

		---search for the git root of the project if specified
		if search_git_root_instead then
			local git_root = find_git_dir(cwd)
			cwd = git_root or cwd ---fallback to cwd
		end
	end

	return cwd, hostname, full_path
end

-- conforming to https://github.com/wez/wezterm/commit/e4ae8a844d8feaa43e1de34c5cc8b4f07ce525dd
-- exporting an apply_to_config function, even though we don't change the users config
M.apply_to_config = function(c, opts)
	-- make the opts arg optional
	if not opts then
		opts = {}
	end

	-- combine user config with defaults
	config = tableMerge(config, opts)

	if c.colors == nil then
		local scheme = wez.color.get_builtin_schemes()[c.color_scheme]
		c.colors = {
			tab_bar = {
				background = scheme.background,
			},
		}
	end
	c.use_fancy_tab_bar = false
	c.tab_bar_at_bottom = config.position == "bottom"
	c.tab_max_width = config.max_width

	-- get user name and store to GLOBAL
end

local function get_current_process_icon(tab_info)
	if tab_info and tab_info.active_pane then
		local process_name = tab_info.active_pane.foreground_process_name
		if process_name then
			-- Convertir a minúsculas para asegurar consistencia
			process_name = process_name:match("^.+/(.+)$") or process_name -- Extraer el nombre base del proceso
			process_name = process_name:lower()
			return process_icons[process_name] or "" -- Retornar el ícono o un ícono por defecto si no está en la tabla
		end
	end
	return ""
end

wez.on("format-tab-title", function(tab, _, _, conf, _, _)
	local palette = conf.resolved_palette
	local index = tab.tab_index + 1
	local number_icon = tab_numbers_outline[index] or index
	local number_current_icon = tab_numbers[index] or index
	local title = tab_title(tab)
	local fg = palette.ansi[6]
	local process_icon = get_current_process_icon(tab)

	if tab.is_active then
		fg = palette.ansi[4]
	end

	local fillerwidth = 4 + index
	local width = conf.tab_max_width - fillerwidth - 1
	if (#title + fillerwidth) > conf.tab_max_width then
		title = wez.truncate_right(title, width) .. "…"
	end

	local number = tab.is_active and number_current_icon or number_icon
	local bg_color = tab.is_active and "#35312C" or palette.tab_bar.inactive_tab.bg_color
	local fg_color = tab.is_active and "#E6CD9A" or "#A89774"
	local bg_number = tab.is_active and "#E6CD9A" or "#272827" -- palette.tab_bar.background -- "#35312C"
	local fg_number = tab.is_active and "#1D282C" or "#A89774"

	return {
		{ Background = { Color = bg_number } },
		-- { Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = fg_number } },
		{ Text = " " .. index .. " " },
		-- { Attribute = { Intensity = "Normal" } },
		{ Background = { Color = bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. title .. " " },

		{ Background = { Color = palette.tab_bar.background } },
		{ Text = " " },
	}
end)

-- Function to get current git branch
---@diagnostic disable-next-line: redefined-local
local function get_git_branch(pane)
	local io = require("io")
	local _, _, cwd = get_cwd_hostname(pane, true)

	-- Ejecutar el comando git en el directorio actual
	local git_cmd = "git -C " .. cwd .. " rev-parse --abbrev-ref HEAD 2>/dev/null"
	local handle = io.popen(git_cmd)

	if handle then
		local branch = handle:read("*a")
		handle:close()

		if branch then
			branch = branch:gsub("%s+", "")
			if branch == "" then
				return nil
			else
				return branch
			end
		end
	end

	return nil
end

-- Name of workspace
wez.on("update-status", function(window, pane)
	local present, conf = pcall(window.effective_config, window)
	if not present then
		return
	end

	wez.log_info(pane:get_foreground_process_name())

	local palette = conf.resolved_palette
	local branch = get_git_branch(pane)

	-- left status
	window:set_left_status(wez.format({
		-- { Background = { Color = "#35312C" } },
		-- { Background = { Color = "#1C272B" } },
		-- { Foreground = { Color = palette.ansi[7] } },
		-- { Text = "  " .. config.branch_icon .. " " .. branch .. "  " },
		-- { Text = " 󰆍" },

		{ Foreground = { Color = "#E6CD9A" } },
		{ Text = "  " .. window:active_workspace() .. "  " },
		--
		-- { Foreground = { Color = "#E6CD9A" } },
		-- { Background = { Color = "#1D282C" } },
		-- { Text = "  " .. config.terminal_icon .. "  " },
		-- { Background = { Color = palette.tab_bar.background } },
		-- { Text = "  " },
		-- { Background = { Color = "#E6CD9A" } },
		-- { Foreground = { Color = "#1D282C" } },
		-- { Text = " " .. process_icon .. " " },
		-- { Text = "  " },
	}))

	-- right status
	local cells = {
		{ Background = { Color = palette.tab_bar.background } },
	}
	local enabled_modules = config.enabled_modules

	if enabled_modules.username then
		table.insert(cells, { Foreground = { Color = palette.ansi[6] } })
		table.insert(cells, { Text = username })
		table.insert(cells, { Foreground = { Color = palette.brights[1] } })
		table.insert(cells, { Text = config.right_separator .. config.user_icon .. config.field_separator })
	end

	local cwd, hostname = get_cwd_hostname(pane, true)
	if enabled_modules.hostname then
		table.insert(cells, { Foreground = { Color = palette.ansi[8] } })
		table.insert(cells, { Text = hostname })
		table.insert(cells, { Foreground = { Color = palette.brights[1] } })
		table.insert(cells, { Text = config.right_separator .. config.hostname_icon .. config.field_separator })
	end

	if enabled_modules.clock then
		table.insert(cells, { Foreground = { Color = palette.ansi[5] } })
		table.insert(cells, { Text = wez.time.now():format("%H:%M") })
		table.insert(cells, { Foreground = { Color = palette.brights[1] } })
		table.insert(cells, { Text = config.right_separator .. config.clock_icon .. "  " })
	end

	if enabled_modules.cwd then
		table.insert(cells, { Foreground = { Color = palette.brights[1] } })
		table.insert(cells, { Text = config.cwd_icon .. " " })
		table.insert(cells, { Foreground = { Color = palette.ansi[7] } })
		table.insert(cells, { Text = cwd .. " " })
	end

	-- Show git branch
	if branch then
		-- table.insert(cells, { Foreground = { Color = "#E6CD9A" } })
		-- table.insert(cells, { Background = { Color = "#1D282C" } })
		-- table.insert(cells, { Text = "" })

		table.insert(cells, { Background = { Color = "#E6CD9A" } })
		table.insert(cells, { Foreground = { Color = "#1d282c" } })
		table.insert(cells, { Text = " " .. config.branch_icon .. " " })

		table.insert(cells, { Background = { Color = "#35312C" } })
		table.insert(cells, { Foreground = { Color = "#E6CD9A" } })
		table.insert(cells, { Text = " " .. branch .. " " })

		-- table.insert(cells, { Foreground = { Color = "#35312C" } })
		-- table.insert(cells, { Background = { Color = "#1D2021" } })
		-- table.insert(cells, { Text = "" })
	else
		table.insert(cells, { Text = "" })
	end

	window:set_right_status(wez.format(cells))
end)

return M
