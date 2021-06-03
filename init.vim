" The following lines make the cursor work
" on hybrid mode when in normal mode and
" absolute line number in insert mode.
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

set ruler " Show cursor line anc column in status line
set colorcolumn=87
syntax enable
set expandtab
set shiftwidth=4
set nowrap
set linebreak
filetype plugin on
set cursorline

" Plugins will be downloaded under the specified directory.
call plug#begin()

" Aesthetics
Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dracula/vim', { 'as': 'dracula' }
" Jump fast!
Plug 'easymotion/vim-easymotion'
" Easy line commenting
Plug 'scrooloose/nerdcommenter'
" Session management and pretty splash screen
Plug 'mhinz/vim-startify'
" Command to run black over python files
Plug 'python/black'
" Autoclose pairs
Plug 'jiangmiao/auto-pairs'
" Surround text objects with pairs
Plug 'tpope/vim-surround'
" Show changed lines on gutter
Plug 'airblade/vim-gitgutter'
" Easy git from within neovim
Plug 'tpope/vim-fugitive'
" Fuzzy file/buffer searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Better buffer deletion
Plug 'qpkorr/vim-bufkill'
" Better code maniuplaution
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
" Autocompletion
Plug 'hrsh7th/nvim-compe'
" Line text object al, il
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
" All this are to get a Jupyter like experience
Plug 'GCBallesteros/iron.nvim'
Plug 'GCBallesteros/vim-textobj-hydrogen'
Plug 'GCBallesteros/jupytext.vim'
" Saner search and highlightiing behaviour
Plug 'wincent/loupe'
Plug 'gfanto/fzf-lsp.nvim'

call plug#end()

" Jupytext
let g:jupytext_fmt = 'py:hydrogen'

" Always keep 5 lines from bottom/top
set scrolloff=5
" for deoplete you also have to install via pip3 neovim and yapf
" and point python3_host_prog to your python3
let g:python3_host_prog='~/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog='~/.pyenv/versions/neovim/bin/python'

" LSP Shortcuts
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    :DocumentSymbols<CR>
nnoremap <silent> gW    :WorkspaceSymbols<CR>

" Search options
set incsearch
set ignorecase
set smartcase

" This unsets the "last search pattern" register by hitting return
nmap <CR> <Plug>(LoupeClearHighlight)

" For airline
set laststatus=2

" New leader
let mapleader=","
let maplocalleader = ";"

" Shortcuts for buffers and files of fzf
nmap ; :Buffers<CR>
nmap <Leader>t :GFiles<CR>

" EasyMotion configuration
let g:EasyMotion_do_mapping = 0 "Disable default mappings
let g:EasyMotion_smartcase = 1
hi link EasyMotionShade  Comment
nmap s <Plug>(easymotion-s2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>f <Plug>(easymotion-bd-fl)

set hidden

" Syntax Highlighting
syntax on

" Full range of color
set termguicolors

if $TERM == "screen-256color"
    colorscheme nightfly
else
    " Fallback for terminals supporting
    " less colors.
    colorscheme dracula
endif

"Trimwhite space easily
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhiteSpace call TrimWhiteSpace()

" Startify options
let g:startify_bookmarks = ['~/.config/nvim/init.vim', '~/.config/nvim/plugins.lua', '~/.zshrc']
let g:startify_change_to_dir = 1
let g:startify_relative_path = 1

" Escape terminal key with ESC
:tnoremap <Esc> <C-\><C-n>

" Disable bloody autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" lightline
let g:lightline = {
    \ 'colorscheme': 'nightfly',
    \ 'active' : {
    \     'left': [ [ 'mode', 'paste' ],
    \               ['readonly', 'filename', 'modified']
    \      ]
    \ },
    \ 'component_function': {
    \    'filename': 'LightlineFilename',
    \ }
    \ }

function! LightlineFilename()
    let root = fnamemodify(get(b:, 'git_dir'), ':h')
    let path = expand('%:p')
    if path[:len(root)-1] ==# root
        return path[len(root)+1:]
    endif
    return expand('%')
endfunction

" Disable scratpad. We just need the floating window
"set completeopt+=preview
set completeopt=menuone,noselect


" Send cell to IronRepl and move to next one.
" Depends on the text object defined in vim-textobj-hydrogen
" You first need to be connected to IronRepl
nmap ]x ctrih]h<CR><CR>

" Quickfix shortcuts
nnoremap ]q :cn<CR>
nnoremap [q :cp<CR>

" Location list shortcuts
nnoremap ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

" Additional configurations
luafile $HOME/.config/nvim/plugins.lua

" Code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldcolumn=1

let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

" How to disable wrap per file
" Edit  $VIMRUNTIME/ftplugin/filetypename.vim
" In that file write towards the end:setlocal wrap

"https://www.asciiart.eu/space/telescopes
