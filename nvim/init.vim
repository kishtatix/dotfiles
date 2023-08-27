syntax on
filetype plugin on
filetype plugin indent on
set tabstop=4
set scrolloff=8
set hidden
set shiftwidth=4
set softtabstop=4
set expandtab
set relativenumber
set nu
set nocompatible
set cmdheight=2
set completeopt=menuone,noinsert,noselect
set noswapfile
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set updatetime=50

" Avoid showing extra messages when using completion
set shortmess+=c
call plug#begin()

Plug 'morhetz/gruvbox'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vimwiki/vimwiki'
Plug 'voldikss/vim-floaterm'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'voldikss/vim-translator'
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'simrat39/rust-tools.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

Plug 'Hoffs/omnisharp-extended-lsp.nvim'
Plug 'ray-x/lsp_signature.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-neotest/neotest-plenary'
Plug 'nvim-neotest/neotest-vim-test'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-neotest/neotest'
Plug 'Issafalcon/neotest-dotnet'
" Plug 'voldikss/vim-translator'

" Plug 'github/copilot.vim'

call plug#end()

let g:translator_target_lang = 'ru'
let g:translator_default_engines = ['google']

filetype plugin indent on
colorscheme tokyonight

autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

set background=dark
set termguicolors
let mapleader=" "
set clipboard+=unnamedplus


map <C-t> :NERDTreeFind<CR>
nnoremap <Leader>j :cn<CR>
nnoremap <Leader>k :cp<CR>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

nnoremap   <silent>   <Leader>t    :Translate<CR>
nnoremap   <silent>   <F7>    :FloatermNew<CR>
nnoremap   <silent>   <Leader>tt  :FloatermNew --autoclose=0 cargo build<CR>
nnoremap   <silent>   <Leader>tr  :FloatermNew --autoclose=0 cargo run<CR>
tnoremap   <silent>   <F7> <C-\><C-n><CR>

map <C-f> <cmd>Telescope find_files<CR>
map <Leader>f <cmd>Telescope live_grep<CR>
map <Leader>' <cmd>Telescope oldfiles<CR>

lua <<EOF
    require'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all"
      ensure_installed = { "help", "c_sharp", "go", "rust", "python" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
    }

 require('telescope').load_extension('fzy_native')
 require('telescope').load_extension('file_browser')
 require('telescope').setup {
     defaults = {
         file_sorter = require('telescope.sorters').get_fzy_sorter,
         mappings = {
             i = {
                 ["<C-k>"] = require('telescope.actions').move_selection_previous,
                 ["<C-j>"] = require('telescope.actions').move_selection_next,
                 ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
                 ["<esc>"] = require('telescope.actions').close,
             }
         }
     },
     extensions = {
         fzy_native = {
             override_generic_sorter = false,
             override_file_sorter = true
         }
     }
 }

local function on_attach(client, buffer)
  -- This callback is called when the LSP is atttached/enabled for this buffer
  -- we could set keymaps related to LSP, etc here.
end

-- omnisharp lsp config
require'lspconfig'.omnisharp.setup {
  cmd = { "/home/klyaksik/omnisharp/run", "--languageserver" , "--hostPID", tostring(pid) },
  root_dir = require("lspconfig").util.root_pattern("*.csproj", "*.sln"),
  init_options = {
      AutomaticWorkspaceInit = true,
    },
}

require "lsp_signature".setup({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "single"
    }
  })

local util = require("lspconfig/util")
require'lspconfig'.gopls.setup{}


local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require("rust-tools").setup(opts)

require('rust-tools').setup(opts)

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
--    ['<C-f>'] = cmp.mapping.select_prev_item(),
--    ['<C-d>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-a>'] = cmp.mapping.scroll_docs(-4),
    ['<C-s>'] = cmp.mapping.scroll_docs(4),
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig').rust_analyzer.setup {
    capabilities = capabilities
}

require'lspconfig'.pyright.setup{
    capabilities = capabilities
}

require'lspconfig'.omnisharp.setup{
    capabilities = capabilities,
    handlers = { ["textDocument/definition"] = require('omnisharp_extended').handler, },
    cmd = { '/usr/bin/OmniSharp', '--languageserver' }
}

require("neotest").setup({
  adapters = {
    require("neotest-dotnet")({
      dap = { justMyCode = false },
    }),
    require("neotest-plenary"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
  },
})

EOF

nnoremap <leader>gb :Telescope git_branches<CR>

"nmap <silent> <leader>gd <Plug>(coc-definition)
nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>gu <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>rr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader><CR> <cmd>lua vim.lsp.buf.code_action()<CR>
vnoremap <leader><CR> <cmd>lua vim.lsp.buf.range_code_action()<CR>
nnoremap <leader>H <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>hh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>cf <cmd>lua vim.lsp.buf.format()<CR>
nnoremap <leader>gt <cmd>lua require("neotest").run.run()<CR>

augroup KLYAKSIK
    autocmd!
    autocmd BufWritePre *.cs lua vim.lsp.buf.format()
    autocmd BufWritePre *.go lua vim.lsp.buf.format()
    autocmd BufWritePre *.rs lua vim.lsp.buf.format()
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\r//e
augroup END
