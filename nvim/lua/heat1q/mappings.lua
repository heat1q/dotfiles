-- Delete text
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- git blame and preview
vim.keymap.set("n", "gh", "<cmd>Gitsigns preview_hunk<CR>")
vim.keymap.set("n", "gH", "<cmd>Gitsigns reset_hunk<CR>")
vim.keymap.set("n", "gb", "<cmd>Gitsigns blame_line<CR>")

-- buffers
--vim.keymap.set("n", "<S-tab>", "<cmd>BufferNext<CR>")

-- Exit insert mode and save just by hitting CTRL-s
vim.keymap.set("i", "<c-s>", "<esc>:w<CR>")
vim.keymap.set("n", "<c-s>", ":w<CR>")

-- unbind space so that <leader><p> does not shift your paste
vim.keymap.set({ "n", "x" }, " ", "<nop>")

-- ================================
-- Leader mapping
-- ================================
-- set space as leader
vim.g.mapleader = " "

-- Find files using Telescope command-line sugar.
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<leader>ffg", "<cmd>Telescope live_grep<CR>")
--vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")

-- Toggle tree and find file
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeFindFile<CR>")

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gv", "<cmd>Gvdiffsplit!<CR>")
vim.keymap.set("n", "<leader>gh", "<cmd>diffget //2<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>diffget //3<CR>")

-- buffers
vim.keymap.set("n", "<leader>qb", ":bd<CR>")
vim.keymap.set("n", "<leader>wb", ":%bd|e#|bd#<CR>")

-- copy to os clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

-- open quickfix list with diagnostics
vim.keymap.set("n", "<leader>qf", function() vim.diagnostic.setqflist({ open = true }) end)

-- harpoon
local harpoon_mark = require("harpoon.mark")
local harpoon_ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", harpoon_mark.add_file)
vim.keymap.set("n", "<leader>fh", harpoon_ui.toggle_quick_menu)
vim.keymap.set("n", "<c-h>", harpoon_ui.nav_prev)
vim.keymap.set("n", "<c-l>", harpoon_ui.nav_next)
vim.keymap.set("n", "<leader>1", function() harpoon_ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon_ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon_ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon_ui.nav_file(4) end)
vim.keymap.set("n", "<leader>5", function() harpoon_ui.nav_file(5) end)
vim.keymap.set("n", "<leader>6", function() harpoon_ui.nav_file(6) end)
vim.keymap.set("n", "<leader>7", function() harpoon_ui.nav_file(7) end)
vim.keymap.set("n", "<leader>8", function() harpoon_ui.nav_file(8) end)
vim.keymap.set("n", "<leader>9", function() harpoon_ui.nav_file(9) end)

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree)

-- Rust
vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp testables<CR>")
vim.keymap.set("n", "<leader>rm", "<cmd>RustLsp expandMacro<CR>")

-- Go
vim.keymap.set("n", "<leader>gf", "<cmd>GoTestFunc<CR>")

-- toggle inlay hints
vim.keymap.set("n", "<leader>ii", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
