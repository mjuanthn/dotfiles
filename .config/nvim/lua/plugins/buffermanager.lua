local M = {
  'j-morano/buffer_manager.nvim',
  lazy = false,
}

M.config = function()
  local opts = { noremap = true }
  local map = vim.keymap.set

  -- Setup
  require('buffer_manager').setup {
    select_menu_item_commands = {
      v = {
        key = '<C-v>',
        command = 'vsplit',
      },
      h = {
        key = '<C-h>',
        command = 'split',
      },
    },
    focus_alternate_buffer = true,
    short_file_names = false,
    short_term_names = true,
    loop_nav = true,
    format_function = function(path)
      local Path = require 'plenary.path'
      local tail = require('telescope.utils').path_tail(path)
      local relative_path = Path:new(path):make_relative(vim.fn.getcwd())
      return string.format('%s (%s)', tail, relative_path), { { { 1, #tail }, 'Constant' } }
    end,
  }
  -- Navigate buffers bypassing the menu
  local bmui = require 'buffer_manager.ui'
  local keys = '1234567890'
  for i = 1, #keys do
    local key = keys:sub(i, i)
    map('n', string.format('<leader>%s', key), function()
      bmui.nav_file(i)
    end, opts)
  end
  -- Just the menu
  map({ 't', 'n' }, '<leader><space>', bmui.toggle_quick_menu, opts)
  -- Open menu and search
  local bmui = require 'buffer_manager.ui'
  map({ 't', 'n' }, '<M-l>', function()
    bmui.toggle_quick_menu()
    -- wait for the menu to open
    vim.defer_fn(function()
      vim.fn.feedkeys '/'
    end, 50)
  end, opts)
  -- Next/Prev
  map('n', '<leader>j', bmui.nav_next, opts)
  map('n', '<leader>k', bmui.nav_prev, opts)

  -- Reordering
  -- vim.api.nvim_command [[
  --     autocmd FileType buffer_manager-menu vnoremap J :m '>+1<CR>gv=gv
  --     autocmd FileType buffer_manager-menu vnoremap K :m '<-2<CR>gv=gv
  -- ]]
end

return M
