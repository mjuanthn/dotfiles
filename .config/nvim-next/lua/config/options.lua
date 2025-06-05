-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--- hide document symbols
vim.g.trouble_lualine = false

local opt = vim.opt

opt.backup = false
opt.backupskip = { "/tmp/*", "/private/tmp/*" }
opt.breakindent = true
opt.formatoptions:append({ "r" })
-- opt.mouse = ""
opt.relativenumber = true
opt.diffopt = "filler,iwhite,internal,linematch:60,algorithm:patience"
opt.splitkeep = "cursor"

opt.foldmethod = "expr"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

local function base64(data)
  data = tostring(data)
  local bit = require("bit")
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local b64, len = "", #data
  local rshift, lshift, bor = bit.rshift, bit.lshift, bit.bor

  for i = 1, len, 3 do
    local a, b, c = data:byte(i, i + 2)
    b = b or 0
    c = c or 0

    local buffer = bor(lshift(a, 16), lshift(b, 8), c)
    for j = 0, 3 do
      local index = rshift(buffer, (3 - j) * 6) % 64
      b64 = b64 .. b64chars:sub(index + 1, index + 1)
    end
  end
end

local function set_user_var(key, value)
  local stdout = vim.loop.new_tty(1, false)
  stdout:write(("\x1bPtmux;\x1b\x1b]1337;SetUserVar=%s=%s\b\x1b\\"):format("IS_VIM", true))
end

set_user_var("IS_NVIM", "true")
