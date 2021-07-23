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
"Plug 'itchyny/lightline.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'folke/tokyonight.nvim'
" Jump fast!
"Plug 'easymotion/vim-easymotion'
Plug 'ggandor/lightspeed.nvim'
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
" fzf for the lsp symbols
Plug 'gfanto/fzf-lsp.nvim'
" A floating terminal
Plug 'voldikss/vim-floaterm'

Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'Chiel92/vim-autoformat'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

" Show bulb when actions are available
Plug 'kosayoda/nvim-lightbulb'
Plug 'ray-x/lsp_signature.nvim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'


Plug 'airblade/vim-rooter'
call plug#end()

" Autoformat everything
au BufWrite * :Autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 1

" Jupytext
let g:jupytext_fmt = 'py:hydrogen'

" Always keep 5 lines from bottom/top
set scrolloff=5
" Have to install via pip3 neovim and yapf
" and point python3_host_prog to your python3
let g:python3_host_prog='~/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog='~/.pyenv/versions/neovim/bin/python'

" LSP Shortcuts
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent>gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent>g0    :DocumentSymbols<CR>
nnoremap <silent>ga    <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent><Leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

" Configure the actions lightbulb
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

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
"let g:EasyMotion_do_mapping = 0 "Disable default mappings
"let g:EasyMotion_smartcase = 1
"hi link EasyMotionShade  Comment
"nmap s <Plug>(easymotion-s2)
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)
"map <Leader>f <Plug>(easymotion-bd-fl)

set hidden

" Syntax Highlighting
syntax on

" Floating terminal shortcut
nnoremap <silent> <F3> :FloatermToggle<CR>
tnoremap <silent> <F3> <C-\><C-N>:FloatermToggle<CR>

" Full range of color
set termguicolors

if $TERM == "screen-256color"
    colorscheme tokyonight
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
let g:startify_relative_path = 1
let g:startify_change_to_vcs_root = 1
let g:startify_use_env = 1
let g:startify_session_persistence = 1
let g:startify_padding_left = 60
let g:my_repos = [
    \ {"line": "TTTR Toolbox","path": '~/Documents/RandomProjects/tttr-toolbox/tttr-toolbox/src/main.rs'},
    \ ]

function! s:list_repos()
    return g:my_repos
  endfunction

let g:startify_lists = [
          "\ { 'type': 'files',     'header': ['   MRU']            },
          "\ { 'type': 'dir',       'header': ['   '. getcwd()] },
          \ { 'type': 'sessions',  'header': [repeat(' ', 50) . '        Sessions']       },
          \ { 'type': 'bookmarks', 'header': [repeat(' ', 50) . '        Bookmarks']      },
          \ { 'type': function('s:list_repos'), 'header': [repeat(' ', 50) . '        Repos']      },
          \ { 'type': 'commands',  'header': [repeat(' ', 50) . '        Commands']       },
          \ ]

" Escape terminal key with ESC
:tnoremap <Esc> <C-\><C-n>

" Disable bloody autocommenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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


" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }


" Code folding
" Start with folds open
set foldlevelstart=99
set foldlevel=99
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldcolumn=1
set foldnestmax=2

" Copy to clipboard when we are working on WSL2
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

" Pretty diagnostics signs
call sign_define('LspDiagnosticsSignError',       { 'text': '' ,'texthl': 'LspDiagnosticsSignError'       })
call sign_define('LspDiagnosticsSignWarning',     { 'text': ' ','texthl': 'LspDiagnosticsSignWarning'     })
call sign_define('LspDiagnosticsSignInformation', { 'text': '', 'texthl': 'LspDiagnosticsSignInformation' })
call sign_define('LspDiagnosticsSignHint',        { 'text': '', 'texthl': 'LspDiagnosticsSignHint'        })


let g:startify_custom_header = [
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣰⣶⣿⣿⣿⡄⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⢠⣿⣿⣿⣶⣆⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣷⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠙⠻⣶⣤⣄⣀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⣀⣠⣤⣶⠟⠋⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣷⣷⣤⣨⡘⣿⣶⣶⣤⣠⣿⡿⠙⣿⣿⣿⣿⣿⣿⣿⣶⣶⣦⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⠋⢿⣿⣄⣤⣶⣶⣿⢃⣅⣤⣾⣾⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀███╗   ██╗██╗   ██╗██╗███╗   ███╗ ⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⡿⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣿⣿⣿⣿⣿⡀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀████╗  ██║██║   ██║██║████╗ ████║ ⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⢂⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⢀⣿⣿⣿⣿⣿⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⡿⣟⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀██╔██╗ ██║██║   ██║██║██╔████╔██║  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣮⣻⢿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⠟⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⢿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠻⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡿⢿⣯⡀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣽⣿⣿⣿⣿⣿⣿⣿⣾⣧⢀⣽⡿⢿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⡇⠠⣀⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀            ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣀⠄⢸⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⣱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀         ⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣎⢿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠔⢉⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀         ⠀ ⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡉⠢⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀         ⠀ ⠀⠀⠀⠀⠀⠀⢴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀         ⠀ ⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ '     ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⡿⡿⠿⠛⠛⠉⠁⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀           ⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠈⠉⠛⠛⠿⢿⢿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
\ ]
"https://www.asciiart.eu/space/telescopes

" shortcut to go to next position
let g:UltiSnipsJumpForwardTrigger='<c-j>'


let g:rooter_manual_only = 1
