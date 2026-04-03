vim.pack.add({
    "https://github.com/onsails/lspkind.nvim",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/ray-x/go.nvim",
    "https://github.com/ray-x/guihua.lua",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",

    "https://github.com/nvimtools/none-ls.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/ThePrimeagen/harpoon",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",

    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/saadparwaiz1/cmp_luasnip",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/saecki/crates.nvim",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/nvim-neotest/neotest",

    "https://github.com/tpope/vim-abolish",
    "https://github.com/rebelot/kanagawa.nvim",
})

-- Post-install hooks
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" then
            vim.cmd("TSUpdate")
        end
        if ev.data.spec.name == "LuaSnip" and ev.data.kind == "install" then
            vim.fn.system("cd " .. ev.data.path .. " && make install_jsregexp")
        end
        if ev.data.spec.name == "tailwind-tools.nvim" then
            vim.cmd("UpdateRemotePlugins")
        end
    end,
})

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    diagnostics = {
        enable = true,
    },
})

require("treesitter-context").setup()

require("gitsigns").setup({
    signcolumn = true,
    numhl = true,
    current_line_blame = true,
})

require("ibl").setup({
    indent = { char = "▏" },
    scope = { enabled = true, show_start = false }
})

require("lualine").setup()

require("nvim-autopairs").setup()

require("nvim-ts-autotag").setup()

require("luasnip.loaders.from_vscode").lazy_load()

require("harpoon").setup()

require("crates").setup()
