" *** vimrc | author: karsen burnett, 2022 ***

" ===================================================================================
" basic configuration
" ===================================================================================

set noerrorbells                        " disable error bells
set lazyredraw                          " lazy redraw (see help for more...)
set scrolloff=5                         " num lines above/below cursor
set nu                                  " line numbers
set autoindent                          " indentation helper
set smartindent                         " indentation helper
set clipboard^=unnamed,unnamedplus      " share cipboard with os
set showcmd                             " command history
set laststatus=2                        " alwasy show status bar
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
silent! set cryptmethod=blowfish2

" comment formatting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" visual mode tab mapping ( this way we can indent via > and < in visual mode)
vmap > >gv
vmap < <gv

" ===================================================================================
" PLUGINS (via vim-plug)
" ===================================================================================

" auto install vim - plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')

" colors / theming
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'crusoexia/vim-monokai'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " remember to do :TSInstall <language>

" autopep8 formatting...
Plug 'tell-k/vim-autopep8'

" indent lines
Plug 'lukas-reineke/indent-blankline.nvim'

" for nvim-cmp...
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" for ultsnip (we are going to try it for now...)
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'


" trees --- ( I am going to be trying out a couple...
" chadtree...
"Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
" nvim-tree
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

" minimap! -- I don't really see what this is adding for me at this point...
" Plug 'wfxr/minimap.vim'

" for tabs...
Plug 'romgrk/barbar.nvim'

" dashboard
" Plug 'glepnir/dashboard-nvim'
Plug 'goolord/alpha-nvim'


" telescope!
Plug 'nvim-lua/plenary.nvim' " requirement for telescope
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

" git
" Plug 'airblade/vim-gitgutter'
Plug 'lewis6991/gitsigns.nvim'

" statusline fun!
" Plug 'itchyny/lightline.vim'

call plug#end()

" ===================================================================================
" colors / themeing
" ===================================================================================
"colorscheme gruvbox
" colorscheme gruvbox-material
syntax on 
colorscheme monokai
hi Normal guibg=NONE ctermbg=NONE


" ===================================================================================
" general plugin config
" ===================================================================================
lua require('plugins')
" gisigns used in statusline
lua require('gitsigns').setup()
" custom statusline
lua require('statusline')
" disable the default mode 
set noshowmode

lua require('dashboard')

lua require('blankline')

" autopep8 setup...(press F8 to atuomagically apply pep8 to current file)
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
let g:autopep8_max_line_length=120 " set the max line length before it will try and do a CR

" --- tab navigation with barbar ---
" Go to previous/next buffer
nnoremap <silent>    <A-h> <Cmd>BufferPrevious<CR>
nnoremap <silent>    <A-l> <Cmd>BufferNext<CR>

nnoremap <silent>    <A-<> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <A->> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>


" --- telescope --- 
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" possibly you could add the lua functions from the readme later...


" git gutter
" set updatetime=100
" autocmd VimEnter * :GitGutterLineNrHighlightsEnable " feature only available in nvim 

autocmd VimEnter * :Gitsigns toggle_numhl

" minimap!
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1


" ===================================================================================
" LSP setup
" ===================================================================================
" load lsp lua config
lua require('lsp')
" prevent cmp suggestions in cmdline
autocmd CmdlineEnter * lua require('cmp').setup({enabled = false})
autocmd CmdlineLeave * lua require('cmp').setup({enabled = true})

" 1. snippets
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" ===================================================================================
" TREE!
" ===================================================================================
"nnoremap <leader>t <cmd>CHADopen<cr>
nnoremap <leader>t <cmd>NvimTreeToggle<cr>
lua require('tree')

" ===================================================================================
" general/misc...
" ===================================================================================

" set tab width for different file types...
autocmd Filetype html,lua setlocal tabstop=2
                   \| setlocal shiftwidth=2
                   \| setlocal softtabstop=2
