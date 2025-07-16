return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            hidden = true,
            exclude = { ".git" },
          },
        },
        hidden = true, -- for hidden files
        ignored = true, -- for .gitignore files
        exclude = { ".git" },
      },
    },
  },
}
