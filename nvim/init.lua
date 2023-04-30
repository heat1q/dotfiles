vim.opt.swapfile = false
vim.opt.scrolloff = 8
vim.opt.scrolljump = 1
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.numberwidth = 3
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.breakindent = true
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- folds
-- vim.opt.nofoldenable = true
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "indent"

--vim.opt.completeopt = 'menuone,noinsert,noselect'
--vim.opt.shortmess += 'c'

-- ==============================================
-- Plugins
-- ==============================================
require("heat1q.plugins")
require("heat1q.lsp")
require("heat1q.autocmds")
require("heat1q.mappings")

-- Colorscheme
vim.opt.termguicolors = true
vim.cmd.colorscheme("kanagawa")
