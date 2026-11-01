return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
      image = {
        enabled = true,
        doc = {
          enabled = true,
          inline = true,
          float = true,
        },
        img_dirs = {
          "img",
          "images",
          "assets",
          "static",
          "public",
          "media",
          "attachments",
          "files",
          "3-resources/files",
        },
      },
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
