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

" Declare the list of plugins.
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'python/black'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'dense-analysis/ale'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-lsp'
Plug 'hkupty/iron.nvim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Always keep 5 lines from bottom/top
set scrolloff=5
" for deoplete you also have to install via pip3 neovim and yapf
" and point python3_host_prog to your python3
let g:python3_host_prog='/Users/garfield/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog='/Users/garfield/.pyenv/versions/neovim/bin/python'
let g:deoplete#enable_at_startup = 1

" LSP Shortcuts
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>

" Search options
set incsearch
set ignorecase
set smartcase
set hlsearch

" Blink words when going for next
" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :nohlsearch<CR><CR>

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

"colorscheme dracula
colorscheme nightfly

"Trimwhite space easily
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhiteSpace call TrimWhiteSpace()

" Flash words when we are jumping on the search
nnoremap <silent> n n:call HLNext(0.2)<CR>
nnoremap <silent> N N:call HLNext(0.2)<CR>
highlight WhiteOnRed ctermbg=blue ctermfg=white

function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'), col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('WhiteOnRed', target_pat, 101)
    redraw
    exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
    call matchdelete(ring)
    redraw
endfunction

" Startify options
let g:startify_bookmarks = ['~/.config/nvim/init.vim',]
let g:startify_change_to_dir = 1
let g:startify_relative_path = 1

" Escape terminal key with ESC
:tnoremap <Esc> <C-\><C-n>

" Disable bloody autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
    \'python': ['black'],
    \ }

" register language server
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

" lightline
let g:lightline = { 'colorscheme': 'nightfly' }

" Disable scratpad. We just need the floating window
set completeopt-=preview

" prep the lsp to work with python
lua <<EOF
require'nvim_lsp'.pyls.setup{}
EOF

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "python",     -- one of "all", "language", or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {"python",  "c", "rust" },  -- list of language that will be disabled
  },
}
EOF

luafile $HOME/.config/nvim/plugins.lua

" How to disable wrap per file
" Edit  $VIMRUNTIME/ftplugin/filetypename.vim
" In that file write towards the end:setlocal wrap
