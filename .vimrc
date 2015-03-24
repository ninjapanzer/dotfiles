syntax on
filetype plugin indent on
set backspace=indent,eol,start

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-haml'
Plugin 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/grep.vim'
Plugin 'vim-scripts/scratch.vim'
if version >= 73584
  Plugin 'Valloric/YouCompleteMe'
endif

"nerdtree
map <C-n> :NERDTreeToggle<CR>

" All of your Plugins must be added before the following line
call vundle#end()

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

"ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"git gutter
