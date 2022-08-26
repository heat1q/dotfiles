call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig' " Collection of common configurations for the Nvim LSP client
Plug 'hrsh7th/nvim-cmp' " Completion framework
Plug 'hrsh7th/cmp-nvim-lsp' " LSP completion source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip' " Snippet completion source for nvim-cmp
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer' " Other usefull completion sources
Plug 'simrat39/rust-tools.nvim' " See hrsh7th's other plugins for more completion sources!
" To enable more of the features of rust-analyzer, such as inlay hints and more!
Plug 'hrsh7th/vim-vsnip' " Snippet engine
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' " Fuzzy finder 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'preservim/nerdcommenter'
Plug 'romgrk/barbar.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'fedepujol/move.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-lua/plenary.nvim' " nvim-go
Plug 'crispgm/nvim-go'
Plug 'ayu-theme/ayu-vim' " color theme

call plug#end()

set termguicolors     " enable true colors support
let ayucolor="dark" " for mirage version of theme
colorscheme ayu

set scrolloff=4
set scrolljump=1

" ui
set number                        " Don't show line numbers
set numberwidth=3                 " The width of the number column
set relativenumber                " Show relative numbers

" indentation
set expandtab                     " Indent with spaces
set shiftwidth=4                  " Number of spaces to use when indenting
set smartindent                   " Auto indent new lines
set softtabstop=4                 " Number of spaces a <tab> counts for when inserting
set tabstop=4                     " Number of spaces a <tab> counts for

" folds
set nofoldenable                  " dont fold by default
set foldlevelstart=99             " Open all folds by default
set foldmethod=indent             " Fold by indentation

" backups and undo
set noswapfile
set history=1000

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local rt = require("rust-tools")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>k', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap("n", "<leader>lf", "<cmd>RustFmt<CR>", opts)
  buf_set_keymap("n", "<C-space>", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

  -- Get signatures (and _only_ signatures) when in argument lists.
  require "lsp_signature".on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
    },
  })
end

-- from https://github.com/simrat39/rust-tools.nvim
rt.setup({
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,

        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        },
    },
})

-- setup nvim-go
require('go').setup({
    auto_format = true,
    auto_lint = false,
    test_flags = {'-v', '-tags=unit,integration'},
     -- show test result with popup window
    test_popup = true,
    test_popup_auto_leave = true,
    test_popup_width = 160,
    test_popup_height = 40,
})

-- setup lsp client
require('lspconfig').gopls.setup({
    on_attach = on_attach,
})

-- setup python lsp
nvim_lsp.pyright.setup{}

-- setup ts language server
nvim_lsp.tsserver.setup{
    on_attach = on_attach,
}

-- setup eslint for js and ts
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
nvim_lsp.eslint.setup{}

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

require("nvim-autopairs").setup {}

require'nvim-web-devicons'.setup {
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "go", "rust", "javascript", "typescript", "python", "hcl" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    auto_install = false,
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
  }

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    if vim.bo.filetype == 'NvimTree' then
      require'bufferline.state'.set_offset(37, 'FileTree')
    end
  end
})

vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*',
  callback = function()
    if vim.fn.expand('<afile>'):match('NvimTree') then
      require'bufferline.state'.set_offset(0)
    end
  end
})

require('gitsigns').setup()
EOF

" ================================
" Autocmds
" ================================

" Fix with eslint on save for ts and js files
autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
" nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
" nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)

" ================================
" Mappings
" ================================

" Documentation navigation
"nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap gy <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <leader>lr <cmd>lua vim.lsp.buf.rename()<CR>
"nnoremap <leader>k <cmd>lua vim.diagnostic.open_float()<CR>
"nnoremap [g <cmd>lua vim.diagnostic.goto_prev()<CR>
"nnoremap ]g <cmd>lua vim.diagnostic.goto_next()<CR>

map <c-z> <nop>
map <c-q> <nop>

" tabs
nnoremap <S-tab> <Cmd>BufferPrevious<cr>
nnoremap <tab> <Cmd>BufferNext<cr>
nnoremap <c-q> <Cmd>BufferClose<cr>

" undo redo on ctl-x and ctrl-y
imap <c-z> <esc>:undo<cr>i
" imap <c-x> <esc>:redo<cr>i
nmap <c-z> :undo<cr>
" nmap <c-y> :redo<cr>

" Exit insert mode and save just by hitting CTRL-s
imap <c-s> <esc>:w<cr>
nmap <c-s> :w<cr>

"fast movement
map <c-down> }
map <c-up> {
map <c-left> b
map <c-right> w

nnoremap <c-h> b
nnoremap <c-l> w
nnoremap <c-k> {
nnoremap <c-j> }

vnoremap <c-h> b
vnoremap <c-l> w
vnoremap <c-k> {
vnoremap <c-j> }

"map <s-h> <s-left>
"map <s-l> <s-right>
"map <s-k> <s-up>
"map <s-j> <s-down>

"vmap <left> h
"vmap <right> l
"vmap <up> k
"vmap <down> j

"Move text around in visual mod
nnoremap <A-down> :MoveLine(1)<cr>
nnoremap <A-up> :MoveLine(-1)<cr>

vnoremap <A-left> <nop>
vnoremap <A-right> <nop>
vnoremap <A-down> :MoveBlock(1)<cr>
vnoremap <A-up> :MoveBlock(-1)<cr>

" Terminal mode
tnoremap <Esc> <C-\><C-n>

" To use `ALT+{h,j,k,l}` to navigate windows from any mode:
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" ================================
" Leader mapping
" ================================
let mapleader = "\<Space>"

" Find files using Telescope command-line sugar.
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Toggle tree and find file
nnoremap <leader>t <cmd>NvimTreeToggle<cr>
nnoremap <leader>r <cmd>NvimTreeFindFile<cr>

