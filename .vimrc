syntax on
filetype off
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set relativenumber
set nu
set nocompatible
set cmdheight=2
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'vifm/vifm.vim' 
Plugin 'morhetz/gruvbox'
Plugin 'phanviet/vim-monokai-pro'
Plugin 'vim-airline/vim-airline'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-fugitive'

call vundle#end()

filetype plugin indent on
colorscheme gruvbox 
set background=dark
set termguicolors

let mapleader=" "
set clipboard=unnamedplus
map <C-t> :NERDTreeToggle<CR>
map <C-f> :Files<CR>
map <Leader>f :Rg<Space>
