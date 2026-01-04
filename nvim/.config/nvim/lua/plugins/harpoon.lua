return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon add file",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon menu",
      },
      {
        "<leader>hl",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon next",
      },
      {
        "<leader>hh",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon prev",
      },
    },
  },
}
