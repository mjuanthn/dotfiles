-- leader key
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--
-- vscode keymaps
local vscode = require('vscode')

if vscode then
  -- test
  keymap({ "n", "x" }, "<CMD-s>", function()
    print "HELLO WORLD"
    print(vscode.call("_ping"))
  end)

  -- refactor
  keymap({ "n", "x" }, "<leader>r", function()
    vscode.with_insert(function()
      vscode.action("editor.action.refactor")
    end)
  end)
end
