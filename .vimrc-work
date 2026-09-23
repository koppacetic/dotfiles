set nocompatible

filetype plugin indent on

" Encoding
set encoding=utf-8

" Tabs
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab smarttab

" Searching
set incsearch
set ignorecase
set smartcase

set visualbell

" make backspaces more powerfull
set backspace=indent,eol,start

" Make sure that unsaved buffers that are put in the background are
" allowed to go in there (ie. no "must save first" error comes up)
set hidden

" Make the 'cw' and like commands put a $ at the end instead of just
" deleting the text and replacing it
set cpoptions=ces$

" Always display a status line
set laststatus=2

" Set status line format
"set statusline=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Show current command in lower right corner
set showcmd
"set cmdheight=2

" Show current mode
set showmode

" Turn on syntax highlighting
syntax on

" Hide the mouse pointer when typing
set mousehide
set mouse=a

" Disable backups
set nobackup
set nowritebackup
set noswapfile

" Fix for pasting indented text
set pastetoggle=<F2>

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"colorscheme desert

