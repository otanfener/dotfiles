return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          enabled = true, -- Enable signature help
          auto_open = {
            enabled = true, -- Show automatically when typing (set to false if you find it annoying)
            trigger = true, -- Automatically show signature help when typing
            throttle = 50, -- Debounce time in ms
          },
        },
      },
    },
  },
}
