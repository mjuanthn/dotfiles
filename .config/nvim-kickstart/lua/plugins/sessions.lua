return {
  {
    'echasnovski/mini.sessions',
    version = false,
    opts = function()
      require('mini.sessions').setup {
        autoread = true,
        autowrite = true,
        directory = '',
        file = 'Session.vim',
        force = { read = false, write = false, delete = false },
        hooks = { pre = { read = nil, write = nil, delete = nil }, post = { read = nil, write = nil, delete = nil } },
        verbose = { read = false, write = true, delete = true },
      }
    end,
  },
}
