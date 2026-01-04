return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
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
