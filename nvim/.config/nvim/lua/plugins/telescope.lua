return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>?",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "[?] Find recently opened files",
      },
      {
        "<leader>sd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "[S]earch [D]iagnostics",
      },
      {
        "<leader>jl",
        function()
          require("telescope.builtin").jumplist()
        end,
        desc = "[J]ump [L]ist",
      },
      {
        "<leader>km",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "[K]ey[M]aps",
      },
      {
        "<leader>rg",
        function()
          require("telescope.builtin").registers()
        end,
        desc = "[R]egisters",
      },
      {
        "<leader>ht",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "[H]elp [T]ags",
      },
    },
  },
}
