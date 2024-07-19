local l = require("utils/lume")

local M = {}

M.apply_to_config = function(config)
	local general_keys = require("keymaps/general")
	local workspace_keys = require("keymaps/workspace")
	local pane_keys = require("keymaps/pane")
	local tab_keys = require("keymaps/tab")

	config.keys = l.concat(config.keys, general_keys, pane_keys, workspace_keys, tab_keys)
end

return M
