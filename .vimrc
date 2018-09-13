" vim: set sw=4 ts=4 sts=4 et:
" ===========================
"  Basic Setting
" ===========================
set background=dark

filetype plugin indent on
syntax on
set hlsearch

scriptencoding utf-8

set history=1000
set spell

set relativenumber
set showmode
set cursorline
set cursorcolumn
set incsearch

set nowrap
set autoindent
set shiftwidth=4
set expandtab
set tabstop=4
set softtabstop=4
set nojoinspaces
set scrolloff=7
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
set cc=80

" ===========================
" Key maps
" ===========================
let mapleader = ','
set pastetoggle=<leader>p
map <S-H> gT
map <S-L> gt
map <C-J> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-L> <C-W>l<C-W>
map <C-H> <C-W>h<C-W>

" ===========================
" Custom Functionalities
" ===========================
" backup, view, swap
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
set backup
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" restore cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" ===========================
" Vim-plug
" ===========================
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'Yggdroot/indentLine'
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'

Plug 'Valloric/YouCompleteMe', { 'do': './install.py'  }
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'

call plug#end()

" ===========================
" Plugin settings
" ===========================
" NERDTree
if isdirectory(expand("~/.vim/bundle/nerdtree"))
    map <C-e> :NERDTreeToggle<CR>

    let NERDTreeShowHidden=1
    let NERDTreeQuitOnOpen=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
endif

" ctrlp
if isdirectory(expand("~/.vim/bundle/ctrlp.vim"))
    let g:ctrlp_working_path_mode = 'ra'
endif

" vim-airline
if isdirectory(expand("~/.vim/bundle/vim-airline"))
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline_powerline_fonts=1
    if isdirectory(expand("~/.vim/bundle/vim-airline-themes"))
        let g:airline_theme = 'simple'
    endif
endif

" colorschemes
if isdirectory(expand("~/.vim/bundle/onedark.vim")) || isdirectory(expand("~/.vim/bundle/vim-colorschemes"))
    colorscheme onedark
    highlight clear LineNr
    hi Normal guibg=NONE ctermbg=NONE
endif

" vim-indent-guides
if isdirectory(expand("~/.vim/bundle/indentLine"))
    " https://misc.flogisoft.com/bash/tip_colors_and_formatting
    let g:indentLine_color_term = 8
endif

" rainbow
if isdirectory(expand("~/.vim/bundle/rainbow/"))
    let g:rainbow_active = 1
endif

" YouCompleteMe
if isdirectory(expand("~/.vim/bundle/YouCompleteMe/"))
    set completeopt-=preview
    " remap Ultisnips for compatibility for YCM
    let g:ycm_key_list_select_completion = ['<C-J>', '<Tab>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-K>', '<S-Tab>', '<Up>']
    map <leader>d :YcmCompleter GoTo<CR>
endif

" vim-gitgutter
if isdirectory(expand("~/.vim/bundle/vim-gitgutter"))
    autocmd BufWritePost * GitGutter
endif
