-- ================================
-- FileType and Tabs
-- ================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust,javascript,javascriptreact,typescript,typescriptreact,python,json",
    callback = function()
        vim.opt.expandtab = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.opt.expandtab = false
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform,lua,ocaml,yaml",
    callback = function()
        vim.opt.expandtab = true
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
    end,
})

--vim.api.nvim_create_autocmd("BufWinEnter", {
--    pattern = "*",
--    callback = function()
--        if vim.bo.filetype == "NvimTree" then
--            require("bufferline.api").set_offset(37, "FileTree")
--        end
--    end,
--})

--vim.api.nvim_create_autocmd("BufWinLeave", {
--    pattern = "*",
--    callback = function()
--        if vim.fn.expand("<afile>"):match("NvimTree") then
--            require("bufferline.api").set_offset(0)
--        end
--    end,
--})
