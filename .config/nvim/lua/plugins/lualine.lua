local M = {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons' },
  enabled = true,
  dependencies = {
    'meuter/lualine-so-fancy.nvim',
  },
}

M.config = function()
  local colors = {
    blue = '#80a0ff',
    cyan = '#8ab3b5',
    black = '#1D2021',
    white = '#c6c6c6',
    red = '#ab6077',
    violet = '#d183e8',
    grey = '#282828',
    green = '#a1b56c',
    grey_soft = '#6a6a6a',
  }

  local base16_meu = {
    normal = {
      a = { fg = colors.white, bg = colors.cyan },
      b = { fg = colors.white, bg = colors.grey },
      c = { fg = colors.white, bg = colors.black },
    },

    insert = { a = { fg = colors.white, bg = colors.green } },
    visual = { a = { fg = colors.white, bg = colors.cyan } },
    replace = { a = { fg = colors.white, bg = colors.red } },

    inactive = {
      a = { fg = colors.grey_soft, bg = colors.black },
      b = { fg = colors.grey_soft, bg = colors.black },
      c = { fg = colors.grey_soft, bg = colors.black },
      x = { fg = colors.grey_soft, bg = colors.black },
      y = { fg = colors.grey_soft, bg = colors.black },
      z = { fg = colors.grey_soft, bg = colors.black },
    },
  }

  local icons = require 'config.icons'
  local diff = {
    'diff',
    colored = true,
    symbols = { added = icons.git.LineAdded, modified = icons.git.LineModified, removed = icons.git.LineRemoved }, -- Changes the symbols used by the diff.
  }

  local fileicon = {
    'filetype',
    colored = true, -- Displays filetype icon in color if set to true
    icon_only = true, -- Display only an icon for filetype
    icon = { align = 'right' }, -- Display filetype icon on the right hand side
    padding = { left = 1, right = 0 },
  }

  local filename = {
    'filename',
    path = 1,
    file_status = true,
    icons_enabled = true,
    no_name = '',
    symbols = {
      modified = '', -- Text to show when the file is modified.
      readonly = icons.diagnostics.BoldError, -- Text to show when the file is non-modifiable or readonly.
      unnamed = '', -- Text to show for unnamed buffers.
      newfile = '', -- Text to show for newly created file before first write
    },
    padding = { left = 1 },
  }

  local group_filename = {
    fileicon,
    {
      'filename',
      path = 0,
      file_status = false,
      icons_enabled = true,
    },
  }
  local group_filepath = {
    filename,
    'fancy_searchcount',
  }

  local group_diagnostics = {
    { 'fancy_diagnostics' },
    'diff',
  }

  ---@diagnostic disable-next-line: unused-local
  local group_branch = {
    group_diagnostics,
    diff,
    { 'fancy_branch' },
    -- { "fancy_cwd", substitute_home = true },
    -- {
    -- 	function()
    -- 		return icons.ui.List .. "%l"
    -- 	end,
    -- },
  }

  require('lualine').setup {
    options = {
      component_separators = { left = '', right = icons.ui.DottedLine .. ' ' },
      section_separators = { left = '', right = '' },
      ignore_focus = { 'NvimTree', 'neo-tree' },
      theme = base16_meu,
      icons_enabled = true,
    },
    sections = {
      -- lualine_a = {},
      -- lualine_b = {},
      -- lualine_c = {}, -- group_filename,
      -- lualine_x = {}, -- group_branch,
      -- lualine_y = {},
      -- lualine_z = {},
    },
    inactive_sections = {
      -- lualine_a = {},
      -- lualine_b = {},
      -- lualine_c = {}, -- { fileicon, filename },
      -- lualine_x = {},
      -- lualine_y = {},
      -- lualine_z = {},
    },
    winbar = {
      lualine_b = group_filename,
      lualine_c = group_filepath,
      lualine_y = {
        { 'diagnostic', 'diff' },
      },
    },
    inactive_winbar = {
      lualine_c = group_filename,
    },
    tabline = {},
    extensions = { 'quickfix', 'man', 'fugitive' },
  }
end

return M
