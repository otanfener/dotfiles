-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("v", "<leader>b", function()
  Snacks.picker.git_log_line()
end, { desc = "Git History for Block" })

vim.keymap.del("n", "<leader>e")
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

map("n", "U", "<c-u>zz")
map("n", "D", "<c-d>zz")

map("n", "<leader>fp", "0<c-g>", { desc = "Show full file path" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

map("n", "J", "mzJ`z", { desc = "Join lines" })
-- markdown
map(
  "n",
  "<leader>da",
  '<cmd>setlocal formatoptions-=a<cr><cmd>setlocal textwidth=0<cr><cmd>echo "Auto-wrapping disabled"<cr>',
  { desc = "Disable auto wrap" }
)
map(
  "n",
  "<leader>ea",
  '<cmd>setlocal formatoptions+=a<cr><cmd>setlocal textwidth=80<cr><cmd>echo "Auto-wrapping enabled"<cr>',
  { desc = "Enable auto wrap" }
)

vim.keymap.set("n", "<leader>bw", "<cmd>bufdo bwipeout<cr>", { desc = "Close all buffers" })

vim.keymap.set("n", "<leader>zn", function()
  require("zk.commands").get("ZkNew")({ dir = "0-inbox" })
end, { noremap = true, silent = false })
