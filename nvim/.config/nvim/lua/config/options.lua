-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

-- General --
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.laststatus = 2 -- show status line
vim.opt.showmatch = true -- highlight matching bracket
vim.opt.signcolumn = "yes" -- always shows sign column
vim.g.root_spec = { "cwd" } -- change root dir

-- Sidebar --
vim.opt.numberwidth = 1
vim.opt.showcmd = true
vim.opt.cmdheight = 0
-- Search --
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.o.incsearch = true -- starts searching as soon as typing, without enter needed
vim.o.ignorecase = true -- ignore letter case when searching
vim.o.smartcase = true -- case insentive unless capitals used in searcher
