set nocompatible              " be iMproved, required

" All autocommands below go in this group, so re-sourcing doesn't duplicate them
augroup vimrc
  autocmd!
augroup END

" --- PLUGINS (vim-plug) ---
" Download vim-plug on first run
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

if filereadable(expand('~/.vim/autoload/plug.vim'))
  " Plugins live outside ~/.vim, which is symlinked into the dotfiles repo
  call plug#begin('~/.local/share/vim/plugged')
  Plug 'preservim/nerdtree'
  Plug 'frazrepo/vim-rainbow'
  Plug 'preservim/nerdcommenter'
  call plug#end()

  " Install any missing plugins on startup
  autocmd vimrc VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
  \| endif
endif

filetype plugin indent on

" --- PLUGIN CONFIGURATION ---
" nerdtree
" show hidden files
let NERDTreeShowHidden=1

" vim-rainbow
" enable rainbow globally
let g:rainbow_active = 1
let g:rainbow_ctermfgs = ['brown', 'darkblue', 'darkgreen', 'darkcyan', 'darkred', 'darkmagenta', 'red', 'lightblue', 'lightgreen']
" --- PLUGIN CONFIGURATION ---

" set PEP8 indentation for python
autocmd vimrc FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=81 expandtab autoindent fileformat=unix

" set indentation for c/h and json
autocmd vimrc FileType c,cpp,json setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent

" set indentation for yaml
autocmd vimrc FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent

" set indentation for full stack dev
autocmd vimrc FileType javascript,html,css setlocal tabstop=2 softtabstop=2 shiftwidth=2

" mark bad white spaces (.h files are detected as cpp)
autocmd vimrc FileType python,c,cpp match BadWhitespace /\s\+$/

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Copy yanks to the system clipboard. Use vim's own clipboard support when it
" works (macOS, or a Linux desktop with an X11-enabled vim). Otherwise (WSL,
" SSH, servers) send yanks to the terminal with the OSC 52 escape sequence, and
" paste with the terminal's own shortcut, e.g. Ctrl+Shift+V.
if has('clipboard_working')
  set clipboard^=unnamed
  if has('unnamedplus')
    set clipboard^=unnamedplus
  endif
elseif has('clipboard_provider')
  packadd osc52
  set clipmethod=osc52
  " Its terminal detection doesn't work inside tmux
  let g:osc52_force_avail = 1
  " Windows Terminal doesn't answer clipboard reads, so don't wait for one
  let g:osc52_disable_paste = 1
  autocmd vimrc TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# ''
    \| call setreg('+', getreg('"'), getregtype('"'))
  \| endif
elseif exists('*echoraw')
  " Older vim without the osc52 package: send the escape sequence directly
  autocmd vimrc TextYankPost * if v:event.operator ==# 'y' && v:event.regname ==# ''
    \| call echoraw("\e]52;c;" . system("base64 | tr -d '\\n'", getreg('"')) . "\x07")
  \| endif
endif

" Enhance command-line completion
set wildmenu

" Allow backspace in insert mode
set backspace=indent,eol,start

" Add the g flag to search/replace by default
set gdefault

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Change mapleader
let mapleader=","

" Don’t add a newline at the end of files that don’t have one
set nofixendofline

" Centralize backups, swapfiles and undo history (outside the dotfiles repo)
let s:state_dir = expand('~/.local/state/vim')
for s:dir in ['backup', 'swap', 'undo']
  call mkdir(s:state_dir . '/' . s:dir, 'p', 0700)
endfor
let &backupdir = s:state_dir . '/backup//'
let &directory = s:state_dir . '/swap//'
let &undodir = s:state_dir . '/undo//'
set undofile

" Respect modeline in files
set modeline
set modelines=4

" Enable line numbers
set number

" Enable syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif

" choose colorscheme
" The colorscheme clears custom highlight groups, so define them afterwards
autocmd vimrc ColorScheme * highlight BadWhitespace ctermbg=red guibg=darkred
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

" Copy indent from the current line when starting a new one
set autoindent
