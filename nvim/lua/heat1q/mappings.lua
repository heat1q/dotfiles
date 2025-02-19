-- Delete text
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- git blame and preview
vim.keymap.set("n", "gh", "<cmd>Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "gH", "<cmd>Gitsigns reset_hunk<cr>")
vim.keymap.set("n", "gb", "<cmd>Gitsigns blame_line<cr>")

-- buffers
--vim.keymap.set("n", "<S-tab>", "<cmd>BufferNext<cr>")

-- Exit insert mode and save just by hitting CTRL-s
vim.keymap.set("i", "<c-s>", "<esc>:w<cr>")
vim.keymap.set("n", "<c-s>", ":w<cr>")

-- unbind space so that <leader><p> does not shift your paste
vim.keymap.set({ "n", "x" }, " ", "<nop>")

-- ================================
-- Leader mapping
-- ================================
-- set space as leader
vim.g.mapleader = " "

-- Find files using Telescope command-line sugar.
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>ffg", "<cmd>Telescope live_grep<cr>")
--vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Toggle tree and find file
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeFindFile<cr>")

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gv", "<cmd>Gvdiffsplit!<cr>")
vim.keymap.set("n", "<leader>gh", "<cmd>diffget //2<cr>")
vim.keymap.set("n", "<leader>gl", "<cmd>diffget //3<cr>")

-- buffers
vim.keymap.set("n", "<leader>qb", ":bd<cr>")
vim.keymap.set("n", "<leader>wb", ":%bd|e#|bd#<cr>")

-- copy to os clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

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
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Rust
vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp testables<cr>")
vim.keymap.set("n", "<leader>rm", "<cmd>RustLsp expandMacro<cr>")

-- Go
vim.keymap.set("n", "<leader>gf", "<cmd>GoTestFunc<cr>")

-- toggle inlay hints
vim.keymap.set("n", "<leader>ii", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

-- copilot
vim.keymap.set('i', '<c-y>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
