-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.cmdheight = 0
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.title = true
vim.opt.termguicolors = true
vim.opt.spell = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.breakindent = true -- maintain indent when wrapping indented lines
vim.opt.linebreak = true -- wrap at word boundaries
vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = "▸ ", trail = "·", nbsp = "␣" }
vim.opt.fillchars:append({ eob = " " }) -- remove the ~ from end of buffer
vim.opt.mouse = "a" -- enable mouse for all modes
vim.opt.mousemoveevent = true -- Allow hovering in bufferline
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.clipboard = "unnamedplus" -- Use Linux system clipboard
vim.opt.confirm = true -- ask for confirmation instead of erroring
vim.opt.undofile = true -- persistent undo
vim.opt.backup = true -- automatically save a backup file
vim.opt.backupdir:remove(".") -- keep backups out of the current directory
vim.opt.shortmess:append({ I = true }) -- disable the splash screen
vim.opt.wildmode = "longest:full,full" -- complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.completeopt = "menuone,longest,preview"
vim.opt.signcolumn = "yes:2"
vim.opt.showmode = false
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.titlestring = "%f // nvim"
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.g.have_nerd_font = true

-- Full height
vim.opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
vim.opt.laststatus = 0 -- always show tabs
vim.opt.showtabline = 0 -- always show tabs
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.opt.showcmd = false

-- Borders
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#FF0000", bg = "NONE" })
