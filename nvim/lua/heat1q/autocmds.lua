-- ================================
-- FileType and Tabs
-- ================================
vim.api.nvim_create_autocmd("FileType", {
    pattern = "rust,javascript,javascriptreact,typescript,typescriptreact,python,lua",
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
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform,ocaml,yaml,json",
    callback = function()
        vim.opt.expandtab = true
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist({ open = false }) 
  end,
})
