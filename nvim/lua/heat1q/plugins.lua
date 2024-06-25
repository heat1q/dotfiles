require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use("neovim/nvim-lspconfig") -- Collection of common configurations for the Nvim LSP client
    use("hrsh7th/nvim-cmp")      -- Completion framework
    use("hrsh7th/cmp-nvim-lsp")  -- LSP completion source for nvim-cmp
    use("hrsh7th/cmp-path")
    --use("hrsh7th/cmp-buffer") -- Other usefull completion sources
    use("simrat39/rust-tools.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("nvim-telescope/telescope.nvim") -- Fuzzy finder; requires fzf, ripgrep installed
    use("preservim/nerdcommenter")
    use("mbbill/undotree")
    use("ray-x/lsp_signature.nvim")
    use("ray-x/go.nvim")
    use("ray-x/guihua.lua")
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")
    use("MunifTanjim/prettier.nvim")
    use("nvimtools/none-ls.nvim")
    use("lewis6991/gitsigns.nvim")
    use("nvim-lualine/lualine.nvim")
    use("windwp/nvim-autopairs")
    use("lukas-reineke/indent-blankline.nvim")
    use("windwp/nvim-ts-autotag")
    use("tpope/vim-fugitive")
    use("ThePrimeagen/harpoon")
    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons", -- optional, for file icons
        },
    })
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })
    use("nvim-treesitter/nvim-treesitter-context")
    use({
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        tag = "v1.*",
        -- install jsregexp (optional!:).
        run = "make install_jsregexp",
        requires = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
    })
    use("saecki/crates.nvim")

    -- Themes
    use("rebelot/kanagawa.nvim")
end)

require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = {
        "go",
        "rust",
        "c",
        "javascript",
        "typescript",
        "python",
        "hcl",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "javascript" },
    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = true,
    },
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

require('crates').setup()
