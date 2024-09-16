local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better save file
function SaveAndDoMore()
  vim.api.nvim_command("stopinsert") -- exit insert mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false) -- exit visual mode
  vim.cmd("VMClear") -- exit multicursors
  vim.cmd("wa") -- save all files
end

-- Weird cmds
vim.api.nvim_create_user_command("W", SaveAndDoMore, {})
vim.api.nvim_create_user_command("Wa", SaveAndDoMore, {})
vim.api.nvim_create_user_command("Wqa", function()
  SaveAndDoMore()
  vim.cmd("qa")
end, {})

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Maintain the cursor position when yanking a visual selection.
keymap("v", "y", "myy`y")
keymap("v", "Y", "myY`y")

-- Easy insertion of a trailing ; or , from insert mode.
keymap("i", ";;", "<Esc>A;<Esc>")
keymap("i", ",,", "<Esc>A,<Esc>")

-- Easy scroll page
keymap({ "n", "v" }, "<C-k>", "<C-u>zz")
keymap({ "n", "v" }, "<C-j>", "<C-d>zz")
keymap({ "n", "v" }, "<C-u>", "<C-u>zz")
keymap({ "n", "v" }, "<C-d>", "<C-d>zz")

keymap("x", "p", [["_dP]])

-- Disable avpag and repag
keymap({ "n", "i" }, "<PageUp>", "<Nop>", { noremap = true, silent = true })
keymap({ "n", "i" }, "<PageDown>", "<Nop>", { noremap = true, silent = true })

-- Disabel cursors
keymap({ "n", "v" }, "<Up>", "<Nop>", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Down>", "<Nop>", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Left>", "<Nop>", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Right>", "<Nop>", { noremap = true, silent = true })
keymap({ "n", "v" }, "<Del>", "<Nop>", { noremap = true, silent = true })

-- Deshabilitar el clic derecho
keymap({ "n", "i" }, "<RightMouse>", "<Nop>", { noremap = true })

-- Disable record to prevent weird commands
keymap("n", "q", "<Nop>", { noremap = true })

-- WEZTERM - moving between splits
if vim.g.vscode == nil then
  vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { noremap = true, silent = true })
end
