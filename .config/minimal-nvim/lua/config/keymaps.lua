local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.opt.hlsearch = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- diagnostics
vim.keymap.set("n", "<leader>k", vim.diagnostic.get_next, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "<leader>j", vim.diagnostic.get_next, { desc = "Go to next [D]iagnostic message" })
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Toggle linenumber and relative numbers in the same keymap
--
function ToggleNumbers()
  vim.wo.relativenumber = false
  if vim.wo.number then
    vim.wo.number = false
  else
    vim.wo.number = true
  end
end

keymap("n", "<leader>ln", ":lua ToggleNumbers()<CR>", opts)

-- Oil file manager
vim.keymap.set("n", "<leader>o", '<CMD>lua require("oil").toggle_float()<CR>', { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>O", "<CMD>lua MiniFiles.open()<CR>", { desc = "Open parent directory" })
