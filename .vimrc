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
set bs=2

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

" Vim indentation based on file type
autocmd BufRead,BufNewFile   *.c,*.h,*.cpp,*.html,*.yaml set sw=2 ts=2 sts=2 et tw=80 nowrap

" Change cursor shape
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

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
Plug 'junegunn/vim-easy-align'
Plug 'chaoren/vim-wordmotion'

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'

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

"coc.nvim
if isdirectory(expand("~/.vim/bundle/coc.nvim"))
    " Disable preview
    set completeopt-=preview

    " if hidden not set, TextEdit might fail.
    set hidden

    " Better display for messages
    set cmdheight=2

    " Smaller updatetime for CursorHold & CursorHoldI
    set updatetime=50

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> for trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[c` and `]c` for navigate diagnostics
    nmap <silent> [c <Plug>(coc-diagnostic-prev)
    nmap <silent> ]c <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if &filetype == 'vim'
        execute 'h '.expand('<cword>')
      else
        call CocActionAsync('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')
    hi default CocHighlightText ctermbg=239

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    vmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocActionAsync('formatSelected')
      " Update signature help on jump placeholder
      "autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    vmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Use `:Format` for format current buffer
    command! -nargs=0 Format :call CocActionAsync('format')

    " Use `:Fold` for fold current buffer
    command! -nargs=? Fold :call CocActionAsync('fold', <f-args>)


    " Add diagnostic info for https://github.com/itchyny/lightline.vim
    let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
          \ },
          \ 'component_function': {
          \   'cocstatus': 'coc#status'
          \ },
          \ }



    " Shortcuts for denite interface
    " Show extension list
    nnoremap <silent> <space>e  :<C-u>Denite coc-extension<cr>
    " Show symbols of current buffer
    nnoremap <silent> <space>o  :<C-u>Denite coc-symbols<cr>
    " Search symbols of current workspace
    nnoremap <silent> <space>t  :<C-u>Denite coc-workspace<cr>
    " Show diagnostics of current workspace
    nnoremap <silent> <space>a  :<C-u>Denite coc-diagnostic<cr>
    " Show available commands
    nnoremap <silent> <space>c  :<C-u>Denite coc-command<cr>
    " Show available services
    nnoremap <silent> <space>s  :<C-u>Denite coc-service<cr>
    " Show links of current buffer
    nnoremap <silent> <space>l  :<C-u>Denite coc-link<cr>
endif

" vim-gitgutter
if isdirectory(expand("~/.vim/bundle/vim-gitgutter"))
    autocmd BufWritePost * GitGutter
endif

" vim-easy-align
if isdirectory(expand("~/.vim/bundle/vim-easy-align"))
    xmap ga <Plug>(EasyAlign)
    nmap ga <Plug>(EasyAlign)
endif

" tagbar
if isdirectory(expand("~/.vim/bundle/tagbar"))
    nmap <F8> :TagbarToggle<CR>
endif
