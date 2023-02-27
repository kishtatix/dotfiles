syntax on
filetype plugin on
filetype plugin indent on
set tabstop=4
set hidden
set shiftwidth=4
set softtabstop=4
set expandtab
set relativenumber
set nu
set nocompatible
set cmdheight=2
"set completeopt=menuone,noinsert,noselect
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'voldikss/vim-translator'


Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'simrat39/rust-tools.nvim'
Plug 'hrsh7th/vim-vsnip'

Plug 'mfussenegger/nvim-dap'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'rcarriga/nvim-dap-ui'

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
set clipboard=unnamedplus


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
map <Leader>' <cmd>Telescope oldfiles<CR>
map <Leader>f :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


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

 --require('telescope').load_extension('fzy_native')
 require('telescope').setup {
     defaults = {
         file_sorter = require('telescope.sorters').get_fzy_sorter,
         mappings = {
             i = {
                 ["<C-k>"] = require('telescope.actions').move_selection_previous,
                 ["<C-j>"] = require('telescope.actions').move_selection_next,
                 ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
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
-- omnisharp lsp config
require'lspconfig'.omnisharp.setup {
  cmd = { "/home/klyaksik/omnisharp/run", "--languageserver" , "--hostPID", tostring(pid) },
  root_dir = require("lspconfig").util.root_pattern("*.csproj", "*.sln"),
  init_options = {
      AutomaticWorkspaceInit = true,
    },
}
local util = require("lspconfig/util")
require'lspconfig'.gopls.setup{}
require'lspconfig'.rust_analyzer.setup{}


local opts = {
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
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

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

local dap = require('dap')

local HOME = os.getenv "HOME"
dap.adapters.coreclr = {
  type = 'executable',
  command = HOME .. '/.local/share/nvim/netcoredbg/netcoredbg',
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

require("nvim-dap-virtual-text").setup()

local dapui = require('dapui')
dapui.setup(
{
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

EOF
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F6> <Cmd>lua require'dap'.close()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>

nnoremap <leader>gb :Telescope git_branches<CR>

nmap <silent> <leader>gd <Plug>(coc-definition)
"nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>

nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <leader>gu <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>rr <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader><CR> <cmd>lua vim.lsp.buf.code_action()<CR>
vnoremap <leader><CR> <cmd>lua vim.lsp.buf.range_code_action()<CR>
nnoremap <leader>H <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>hh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>cf <cmd>lua vim.lsp.buf.formatting()<CR>


augroup KLYAKSIK
    autocmd!
    autocmd BufWritePre *.cs lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\r//e
augroup END
