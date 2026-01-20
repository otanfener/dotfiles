-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically equalize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Close Neo-tree before session save to prevent restore errors
vim.api.nvim_create_autocmd("User", {
  pattern = "PersistenceSavePre",
  callback = function()
    vim.cmd("Neotree close")
  end,
})

-- OSC7: Report current working directory to terminal
-- Enables tmux/terminal splits to open in Neovim's current directory
local function osc7_notify()
  local cwd = vim.fn.getcwd()
  local hostname = vim.fn.hostname()
  local osc7 = string.format("\027]7;file://%s%s\027\\", hostname, cwd)
  vim.fn.chansend(vim.v.stderr, osc7)
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "BufEnter" }, {
  callback = osc7_notify,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.fn.chansend(vim.v.stderr, "\027]7;\027\\")
  end,
})
