set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'preservim/nerdtree'
Plugin 'frazrepo/vim-rainbow'
Plugin 'preservim/nerdcommenter'
"Plugin 'tmhedberg/SimpylFold'
"Plugin 'vim-scripts/indentpython.vim'
"Plugin 'valloric/youcompleteme'
"Plugin 'vim-syntastic/syntastic'
"Plugin 'nvie/vim-flake8'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
highlight BadWhitespace ctermbg=red guibg=darkred

" --- PLUGIN CONFIGURATION ---
" nerdtree
" show hidden files
let NERDTreeShowHidden=1

" vim-rainbow
" enable rainbow globally
let g:rainbow_active = 1
" --- PLUGIN CONFIGURATION ---

" set PEP8 indentation for python
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=81 expandtab autoindent fileformat=unix

" set indentation for c/h
au BufNewFile,BufRead *.c,*.cpp,*h,*virl set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent

" set indentation for full stack dev
au BufNewFile,BufRead *.js,*.html,*.css set tabstop=2 softtabstop=2 shiftwidth=2

" mark bad white spaces
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

""python with virtualenv support
"python3 << EOF
"import os
"import sys
"if 'VIRTUAL_ENV' in os.environ:
  "project_base_dir = os.environ['VIRTUAL_ENV']
  "activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  "execfile(activate_this, dict(__file__=activate_this))
"EOF
"let python_highlight_all=1

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Enhance command-line completion
set wildmenu

" Allow cursor keys in insert mode
set esckeys

" Allow backspace in insert mode
set backspace=indent,eol,start

" Optimize for fast terminal connections
set ttyfast

" Add the g flag to search/replace by default
set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Change mapleader
let mapleader=","

" Don’t add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swapfiles and undo history
"set backupdir=~/.vim/backups
"set directory=~/.vim/swaps
"if exists("&undodir")
	"set undodir=~/.vim/undo
"endif

" Respect modeline in files
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Enable line numbers
set number

" Enable syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif

" choose colorscheme
set background=dark
colorscheme solarized

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

" Highlight searches
set hlsearch

" Ignore case of searches
"" set ignorecase

" Highlight dynamically as pattern is typed
set incsearch

" Always show status line
set laststatus=2

" Enable mouse in all modes
set mouse=a

" Disable error bells
"" set noerrorbells

" Don’t reset cursor to start of line when moving around.
set nostartofline

" Show the cursor position
set ruler

" Don’t show the intro message when starting Vim
set shortmess=atI

" Show the current mode
set showmode

" Show the filename in the window titlebar
set title

" Show the (partial) command as it’s being typed
set showcmd

" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

set ai
set si
