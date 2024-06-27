return {
  {
    "nvim-neorg/neorg",
    ft = "norg",
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
        config = true,
      },
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.dirman"] = {
          config = {
            workspaces = {
              work = "~/Git/Notes/work",
              home = "~/Git/Notes/home",
            },
          },
        },
        ["core.norg.completion"] = {
          config = { engine = "nvim-cmp" },
        },
        ["core.integrations.nvim-cmp"] = {},
      },
    },
  },
}
