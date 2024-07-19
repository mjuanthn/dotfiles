local k = require("utils/keys")
local act = require("wezterm").action

return {
	k.cmd_to_tmux_prefix("1", "1"),
	k.cmd_to_tmux_prefix("2", "2"),
	k.cmd_to_tmux_prefix("3", "3"),
	k.cmd_to_tmux_prefix("4", "4"),
	k.cmd_to_tmux_prefix("5", "5"),
	k.cmd_to_tmux_prefix("6", "6"),
	k.cmd_to_tmux_prefix("7", "7"),
	k.cmd_to_tmux_prefix("8", "8"),
	k.cmd_to_tmux_prefix("9", "9"),
	k.cmd_to_tmux_prefix("G", "G"),
	k.cmd_to_tmux_prefix("g", "g"),
	k.cmd_to_tmux_prefix("L", "L"), -- next session
	k.cmd_to_tmux_prefix("n", '"'), -- split bottom
	k.cmd_to_tmux_prefix("N", "%"), -- split left
	k.cmd_to_tmux_prefix("w", "x"), -- close pane
	k.cmd_to_tmux_prefix("t", "c"), -- create pane
	k.cmd_to_tmux_prefix("k", "K"), -- open sesh
	k.cmd_to_tmux_prefix("T", "T"), -- switch sesion
	k.cmd_to_tmux_prefix("r", ","), -- rename panel
	k.cmd_to_tmux_prefix("R", "$"), -- rename session
	k.cmd_to_tmux_prefix("Y", "Y"), -- rename session
}
