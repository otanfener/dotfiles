return {
  -- Configure gopls (Go Language Server)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              usePlaceholders = false, -- Disable parameter placeholder expansion
            },
          },
        },
      },
    },
  },
}
