vim.lsp.inlay_hint.enable(true)

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local lspkind = require('lspkind')
local cmp = require("cmp")
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({

            mode = "symbol_text",
            menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latex]",
            })
        }),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        -- Add tab support
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
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
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    -- Installed sources
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        --{ name = "buffer" },
        { name = "luasnip", option = { use_show_condition = false } },
    },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts#neovim-08
local lsp_formatting_async = function(bufnr)
    vim.lsp.buf.format({
        filter = function(_)
            return true
        end,
        bufnr = bufnr,
        async = async,
    })
end

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

-- LSP keybindings and format-on-save via LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "gn", function() vim.diagnostic.jump({ count = 1 }) end, opts)
        vim.keymap.set("n", "gN", function() vim.diagnostic.jump({ count = -1 }) end, opts)
        vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, opts)

        if client and client:supports_method("textDocument/formatting") then
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
    end,
})

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

local null_ls = require("null-ls")
local null_ls_sources = {
    null_ls.builtins.formatting.pg_format,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.ocamlformat,
    null_ls.builtins.formatting.prettier,
}

null_ls.setup({
    sources = null_ls_sources,
})

vim.g.rustaceanvim = {
    --test_executor_alias = "neotest",
    -- Plugin configuration
    tools = {},
    -- LSP configuration
    server = {
        capabilities = capabilities,
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                    --allTargets = false,
                },
                diagnostics = {
                    disabled = { "macro-error" },
                },
                procMacro = {
                    enable = true,
                },
                checkOnSave = true,
            },
        },
    },
}

require("go").setup({
    goimports = "goimports", -- goimport command
    gofmt = "golines",      --gofmt cmd,
    max_line_len = 80,      -- max line length in goline format
    tag_transform = "camelcase",  -- tag_transfer  check gomodifytags for details
    verbose = true,         -- output loginf in messages
    log_path = vim.fn.expand("$HOME") .. "/gonvim.log",
    lsp_cfg = {
        capabilities = capabilities,
        settings = {
            gopls = {
                analyses = {
                    ST1003 = false,
                },
            },
        },
    },                         -- true: apply go.nvim non-default gopls setup
    lsp_gofumpt = true,        -- true: set default gofmt in gopls format to gofumpt
    lsp_on_attach = nil,        -- handled by LspAttach autocmd

    lsp_codelens = true,
    diagnostic = {   -- set diagnostic to false to disable vim.diagnostic setup
        hdlr = true, -- hook lsp diag handler
        underline = true,
        -- virtual text setup
        virtual_text = { space = 0, prefix = '■' },
        signs = true,
        update_in_insert = false,
    },
    lsp_inlay_hints = {
        enable = true,
    },
    build_tags = "unit,integration",
    test_runner = "richgo",  -- richgo, go test, richgo, dlv, ginkgo
    verbose_tests = true,    -- set to add verbose flag to tests
    run_in_floaterm = true,  -- set to true to run in float window.
})

-- setup python lsp
vim.lsp.config('pyright', {
    capabilities = capabilities,
})
vim.lsp.enable('pyright')

-- setup ts language server
vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
    },
})
vim.lsp.enable('ts_ls')

-- setup eslint for js and ts
vim.lsp.config('eslint', {
    capabilities = capabilities,
    settings = {
        format = false,
    },
})
vim.lsp.enable('eslint')

vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
vim.lsp.enable('lua_ls')

vim.lsp.config('clangd', {
    capabilities = capabilities,
})
vim.lsp.enable('clangd')

vim.lsp.config('ocamllsp', {
    capabilities = capabilities,
})
vim.lsp.enable('ocamllsp')


-- setup Terraform language server
vim.lsp.config('terraformls', {
    capabilities = capabilities,
})
vim.lsp.enable('terraformls')

-- setup Latex ls
vim.lsp.config('ltex', {
    capabilities = capabilities,
    settings = {
        ltex = {
            language = "en-US",
        },
    },
})
vim.lsp.enable('ltex')

require("neotest").setup({
    adapters = {
        require('rustaceanvim.neotest')
    },
})

