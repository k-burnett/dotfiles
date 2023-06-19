" *** vimrc | author: karsen burnett, 2023 ***

" ===================================================================================
" basic configuration - SETS
" ===================================================================================

set noerrorbells                        " disable error bells
set lazyredraw                          " lazy redraw (see help for more...)
set scrolloff=5                         " num lines above/below cursor
set nu                                  " line numbers
set autoindent                          " indentation helper
set smartindent                         " indentation helper
set showcmd                             " command history
set backspace=indent,eol,start          " allow backspace over indent, eol, start
set timeoutlen=500                      " shorten timeoutlen to 500
set whichwrap=b,s                       " wrap on specified keys
set shortmess=aT                        " message config (see help for more...)
set hlsearch                            " highlight searches (play with this...)
set incsearch                           " highlight search as you type
set hidden                              " hide rather than unload abandoned buffers
set ignorecase smartcase                " helps out searching
set wildmenu                            " command tab completion
set wildmode=longest:full,full          " options for wildmenu (see help...)
set tabstop=4                           " tab config ... see help for more...
set shiftwidth=4
set softtabstop=4
set expandtab smarttab
set virtualedit=block                   " allow virtual editing in block mode
set nojoinspaces                        " remove extra spaces when using 'J' to join lines
" if you start using vimdiff - you may want to look at the diffopt settings...
set autoread                            " update if changes made outside of vim
"set cursorline
set nrformats=alpha,octal,hex,bin       " increment values specified with CTR: + A and decrement with CTR: + X
set colorcolumn=121
set termguicolors
set noshowmode
set re=0

silent! set cryptmethod=blowfish2

syntax on

" comment formatting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" set tab width for different file types...
autocmd Filetype html,lua setlocal tabstop=2
                   \| setlocal shiftwidth=2
                   \| setlocal softtabstop=2

" visual mode tab mapping ( this way we can indent via > and < in visual mode)
vmap > >gv
vmap < <gv

lua require("setup")

" colorscheme
colorscheme tokyonight-storm
