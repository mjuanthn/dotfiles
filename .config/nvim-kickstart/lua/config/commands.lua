-- telescope pickers
vim.cmd [[command! -nargs=0 GoToFile :Telescope smart_open]]

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.cmd 'lcd %:p:h'
  end,
})

-- snacks picker
-- vim.cmd [[command! -nargs=0 GoToCommand :lua Snacks.picker.command_history()]]
-- vim.cmd [[command! -nargs=0 GoToFile :lua Snacks.picker.smart()]]
-- vim.cmd [[command! -nargs=0 GoToSymbol :lua Snacks.picker.lsp_symbols()]]
-- vim.cmd [[command! -nargs=0 Grep :lua Snacks.picker.grep()]]
