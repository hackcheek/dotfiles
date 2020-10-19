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
syntax enable
set expandtab
set shiftwidth=4
set nowrap
set linebreak
filetype plugin on

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Aesthetics
Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dracula/vim', { 'as': 'dracula' }
" Jump fast!
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'python/black'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Better buffer deletion
Plug 'qpkorr/vim-bufkill'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
" Line text object al, il
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
" All this are to get a Jupyter like experience
Plug 'GCBallesteros/iron.nvim'
Plug 'GCBallesteros/vim-textobj-hydrogen'
Plug 'GCBallesteros/jupytext.vim'
" Saner search and highlightiing behaviour
Plug 'wincent/loupe'
" Have NVIM everywhere in your browser (Disabled until better experience)
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Jupytext
let g:jupytext_fmt = 'py:hydrogen'
"let g:jupytext_filetype_map = {"py:asdf": 'r'}

" Always keep 5 lines from bottom/top
set scrolloff=5
" for deoplete you also have to install via pip3 neovim and yapf
" and point python3_host_prog to your python3
let g:python3_host_prog='~/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog='~/.pyenv/versions/neovim/bin/python'
let g:deoplete#enable_at_startup = 1

" LSP Shortcuts
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

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
nmap <Leader>t :Files<CR>

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
let g:startify_bookmarks = ['~/.config/nvim/init.vim',]
let g:startify_change_to_dir = 1
let g:startify_relative_path = 1

" Escape terminal key with ESC
:tnoremap <Esc> <C-\><C-n>

" Disable bloody autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" register language server
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

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
set completeopt-=preview

" Send cell to IronRepl and move to next one.
" Depends on the text object defined in vim-textobj-hydrogen
" You first need to be connected to IronRepl
"nmap ]x ctrih/^# \%\%<CR><CR>
nmap ]x ctrih]h<CR><CR>


" Diagnostics customizations for LSP
"call sign_define("LspDiagnosticsErrorSign", {"text" : "❌", "texthl" : "LspDiagnosticsError"})
"call sign_define("LspDiagnosticsWarningSign", {"text" : "⚠️", "texthl" : "LspDiagnosticsWarning"})

" Quickfix shortcuts
nnoremap ]q :cn<CR>
nnoremap [q :cp<CR>

" Location list shortcuts
nnoremap ]d :NextDiagnosticCycle<CR>
nnoremap [d :PrevDiagnosticCycle<CR>

" Additional configurations
luafile $HOME/.config/nvim/plugins.lua

" How to disable wrap per file
" Edit  $VIMRUNTIME/ftplugin/filetypename.vim
" In that file write towards the end:setlocal wrap
