call plug#begin('~/.vim/plugged')

Plug 'shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1

Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-sensible'

Plug 'ollykel/v-vim'
let g:v_autofmt_bufwritepre = 1

call plug#end()

set laststatus=2
if !has('gui_running')
	set t_Co=256
endif

set ts=4 sw=4
syntax on
set showmatch

set noshowmode
set relativenumber
