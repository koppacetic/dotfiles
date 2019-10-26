set nocompatible

" ======== Vundle Setup ========
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'ycm-core/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'

Plugin 'nvie/vim-flake8'
Plugin 'vim-scripts/indentpython.vim'

Plugin 'fatih/vim-go'

Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
" ======== Vundle Setup ========

filetype plugin indent on

" Make Syntastic and vim-go play nice together
let g:syntastic_go_checkers = ['golint', 'govet']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_list_type = "quickfix"

" vim-go config
let g:go_addtags_transform = "camelcase"
let g:go_highlight_types = 1

" Turn on syntax highlighting
let python_highlight_all=1
syntax on

" Tabs
set tabstop=4 shiftwidth=4 expandtab smarttab

" Show line numbers
"set number

" Disable backups
set nobackup
set nowritebackup
set noswapfile

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" make backspaces more powerfull
set backspace=indent,eol,start

" Hide the mouse pointer when typing
set mousehide

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

let g:netrw_liststyle=3

set wrap
set textwidth=120
set formatoptions=tcqrn1
set noshiftround

" Security
set modelines=0

" Cursor motion
set scrolloff=3
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Status bar
set laststatus=2

" Set status line format
"set statusline=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
set statusline=%<%f\ %h%m%r%=%-20.(Line:\ %l/%L\ \ Col:\ %c%)\ %P

" Show current command in lower right corner
set showcmd

" Show current mode
set showmode

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

"colorscheme zenburn

" ==== YouCompleteMe ====
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

