" ============================================================================
" Basic Vim Configuration for Coding
" ============================================================================

" Enable syntax highlighting and filetype detection
syntax on
filetype plugin indent on

" ============================================================================
" Display Settings
" ============================================================================
set number                  " Show line numbers
" set relativenumber          " Show relative line numbers
set showcmd                 " Show command in bottom bar
set wildmenu                " Visual autocomplete for command menu
set showmatch               " Highlight matching brackets
set ruler                   " Show cursor position
set laststatus=2            " Always show status line

" ============================================================================
" Indentation
" ============================================================================
set tabstop=4               " Number of spaces per tab
set shiftwidth=4            " Number of spaces for autoindent
set expandtab               " Use spaces instead of tabs
set autoindent              " Copy indent from current line
set smartindent             " Smart autoindenting for C-like languages

" ============================================================================
" Search Settings
" ============================================================================
set ignorecase              " Case insensitive search
set smartcase               " Case sensitive if uppercase present
set incsearch               " Search as you type
set hlsearch                " Highlight search results

" ============================================================================
" Editor Behavior
" ============================================================================
set backspace=indent,eol,start  " Make backspace work as expected
set scrolloff=8             " Keep 8 lines visible above/below cursor
set mouse=a                 " Enable mouse support

" ============================================================================
" Split Behavior
" ============================================================================
set splitbelow              " Horizontal splits open below
set splitright              " Vertical splits open to the right

" ============================================================================
" Persistent Undo
" ============================================================================
set undofile                " Enable persistent undo
set undodir=~/.vim/undodir  " Undo directory (create it manually)

" ============================================================================
" Plugin Management (vim-plug)
" Install vim-plug first:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then run :PlugInstall in vim
" ============================================================================
call plug#begin('~/.vim/plugged')

" Color scheme
Plug 'morhetz/gruvbox'

" File navigation
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Linting and syntax checking
Plug 'dense-analysis/ale'

" Auto-close brackets and quotes
Plug 'jiangmiao/auto-pairs'

call plug#end()

" ============================================================================
" Color Scheme Settings
" ============================================================================
set termguicolors           " Enable 24-bit RGB colors
set background=dark         " Use dark background
" colorscheme gruvbox         " Apply gruvbox theme

" ============================================================================
" Plugin Settings
" ============================================================================

" NERDTree toggle with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" FZF shortcuts
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>

" ============================================================================
" Custom Key Mappings
" ============================================================================

" Clear search highlighting with Esc
nnoremap <esc> :noh<return><esc>

" Save with Ctrl+s (requires terminal setup)
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
