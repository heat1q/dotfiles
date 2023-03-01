local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        -- Add tab support
        ["<C-d>"] = cmp.mapping.scroll_docs( -4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    -- Installed sources
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "luasnip", option = { use_show_condition = false } },
    },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- Overwrite global diagnostic handler to use a bordered float
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local nvim_lsp = require("lspconfig")

local lsp_signature = require("lsp_signature")
lsp_signature.setup({
    bind = true,
    doc_lines = 0,
    floating_window = true,
    floating_window_above_cur_line = true,
    hint_enable = false, -- virtual hint enable
    close_timeout = 1,
    floating_window_off_x = 10,
    floating_windows_off_y = 0,
    fix_pos = false,
    handler_opts = {
        border = "rounded",
    },
    max_height = 4,
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts#neovim-08
local lsp_formatting_async = function(bufnr)
    vim.lsp.buf.format({
        filter = function(_)
            -- apply whatever logic you want (in this example, we'll only use null-ls)
            -- clients for which format on save should be enabled
            return true -- client.name == "null-ls"
        end,
        bufnr = bufnr,
        async = async,
    })
end

local null_ls = require("null-ls")
local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"
local null_ls_sources = {
    null_ls.builtins.formatting.pg_format,
    null_ls.builtins.formatting.stylua,
}

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    buf_set_keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    buf_set_keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    buf_set_keymap("n", "gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<C-space>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

    if client.supports_method("textDocument/formatting") then
        --vim.keymap.set("n", "<Leader>f", function()
        --  vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
        --end, { buffer = bufnr, desc = "[lsp] format" })

        -- format on save
        vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
        vim.api.nvim_create_autocmd(event, {
            buffer = bufnr,
            group = group,
            callback = function()
                lsp_formatting_async(bufnr)
            end,
            desc = "[lsp] format on save",
        })
    end
end

-- Set updatetime for CursorHold
-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 300
-- Show diagnostic popup on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})

-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.opt.signcolumn = "yes"

null_ls.setup({
    sources = null_ls_sources,
    on_attach = on_attach,
})

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local rt = require("rust-tools")
rt.setup({
    tools = {
        autoSetHints = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        on_attach = on_attach,
        settings = {
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true,
                },
                completion = {
                    autoimport = {
                        enable = true,
                    },
                    postfix = {
                        enable = false,
                    },
                },
                diagnostics = {
                    disabled = { "macro-error" },
                },
                procMacro = {
                    enable = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
})

require("go").setup({
    goimport = "goimports", -- goimport command
    gofmt = "gofumpt", --gofmt cmd,
    max_line_len = 120, -- max line length in goline format
    tag_transform = false, -- tag_transfer  check gomodifytags for details
    verbose = true, -- output loginf in messages
    log_path = vim.fn.expand("$HOME") .. "/gonvim.log",
    lsp_cfg = {
        capabilities = capabilities,
    }, -- true: apply go.nvim non-default gopls setup
    lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = on_attach, -- if a on_attach function provided:  attach on_attach function to gopls
    -- true: will use go.nvim on_attach if true
    -- nil/false do nothing

    lsp_codelens = true,
    -- gopls_remote_auto = true, -- set to false is you do not want to pass -remote=auto to gopls(enable share)
    -- gopls_cmd = nil,
    -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile", "/var/log/gopls.log" }
    lsp_diag_hdlr = true, -- hook lsp diag handler
    dap_debug = true, -- set to true to enable dap
    dap_debug_keymap = true, -- set keymaps for debugger
    dap_debug_gui = true, -- set to true to enable dap gui, highly recommand
    dap_debug_vt = true, -- set to true to enable dap virtual text
    build_tags = "unit,integration",
    test_runner = "richgo", -- richgo, go test, richgo, dlv, ginkgo
    verbose_tests = true, -- set to add verbose flag to tests
    run_in_floaterm = true, -- set to true to run in float window.
})

-- setup python lsp
nvim_lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- setup ts language server
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
    },
})

-- setup eslint for js and ts
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
nvim_lsp.eslint.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        format = false,
    },
})

nvim_lsp.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

require("prettier").setup({
    bin = "prettier", -- or `'prettierd'` (v0.22+)
    filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
    },
})

-- setup Terraform language server
nvim_lsp.terraformls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
