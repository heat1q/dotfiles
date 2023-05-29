-- Delete text
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- git blame and preview
vim.keymap.set("n", "gh", "<cmd>Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "gH", "<cmd>Gitsigns reset_hunk<cr>")
vim.keymap.set("n", "gb", "<cmd>Gitsigns blame_line<cr>")

-- buffers
vim.keymap.set("n", "<S-tab>", "<cmd>BufferNext<cr>")

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
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeFindFile<cr>")

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gv", "<cmd>Gvdiffsplit!<cr>")
vim.keymap.set("n", "<leader>gh", "<cmd>diffget //2<cr>")
vim.keymap.set("n", "<leader>gl", "<cmd>diffget //3<cr>")

-- buffers
vim.keymap.set("n", "<leader>q", "<cmd>BufferClose<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>BufferCloseAllButCurrent<cr>")

-- copy to os clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
