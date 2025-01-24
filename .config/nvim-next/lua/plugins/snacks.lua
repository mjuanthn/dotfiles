return {
  "snacks.nvim",
  opts = {
    indent = { enabled = false },
    dashboard = {
      preset = {
        header = "",
        keys = {
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "keys", gap = 1, padding = 1 },
      },
    },
    bigfile = {
      size = 0.5 * 1024 * 1024,
    },
  },
}
