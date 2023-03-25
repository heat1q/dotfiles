-- Delete text
vim.keymap.set({ "n", "x" }, "x", '"_x')

-- git blame and preview
vim.keymap.set("n", "gb", "<cmd>Gitsigns preview_hunk<cr>")

-- buffers
vim.keymap.set("n", "<S-tab>", "<cmd>BufferPrevious<cr>")
vim.keymap.set("n", "<tab>", "<cmd>BufferNext<cr>")
vim.keymap.set("n", "<c-q>", "<cmd>BufferClose<cr>")

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
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>g", "<cmd>Telescope git_files<cr>")
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- Toggle tree and find file
vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeFindFile<cr>")