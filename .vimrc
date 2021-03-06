" .vimrc
" Author: Ciaran Downey <code@ciarand.me>
"
" Pieces stolen from:
"
"  - Steve Losh <steve@stevelosh.com>
"  - Tim Pope <github@tpope.org>
"
" I make no promises.

" Plugins ----------------------------------------------------------------- {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Rip-Rip/clang_complete'         " better support for c-langs
Plugin 'Valloric/YouCompleteMe'         " autocompletion
Plugin 'benmills/vimux'                 " same as above but to a dedicated pane
Plugin 'cbracken/vala.vim'              " vala syntax
Plugin 'chase/vim-ansible-yaml'         " ansible-specific yml syntax
Plugin 'chriskempson/base16-vim'        " cool color schemes
Plugin 'christoomey/vim-tmux-navigator' " navigate tmux / vim panes easily
Plugin 'editorconfig/editorconfig-vim'  " editorconfig support
Plugin 'edkolev/promptline.vim'         " cool status bar for bash
Plugin 'edkolev/tmuxline.vim'           " cool status bar for tmux
Plugin 'evanmiller/nginx-vim-syntax'    " nginx syntax
Plugin 'fatih/vim-go'                   " awesome support for go
Plugin 'godlygeek/tabular'              " aligns things
Plugin 'itchyny/lightline.vim'          " cool status bar at bottom
Plugin 'wting/rust.vim'                 " rust support (inc. syntastic checker)
Plugin 'elixir-lang/vim-elixir'         " Elixir support
Plugin 'sheerun/vim-polyglot'           " language pack for a bunch of stuff
Plugin 'openscad.vim'                   " openSCAD support
Plugin 'airblade/vim-gitgutter'         " signs in the gutter
Plugin 'scrooloose/syntastic'           " runs linters n stuff
Plugin 'tpope/vim-dispatch'             " dispatch tasks to other tmux panes
Plugin 'tpope/vim-fugitive'             " git wrapper
Plugin 'tpope/vim-sensible'             " sensible defaults
Plugin 'tpope/vim-vinegar'              " helpers for netrw explorer
Plugin 'xsbeats/vim-blade'              " blade syntax

call vundle#end()

filetype plugin indent on

" }}}

" Basic options ----------------------------------------------------------- {{{

set encoding=utf-8
set modelines=0
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set fileformats=unix
set number
set norelativenumber
set laststatus=2
set history=1000
set undofile
set undoreload=10000
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:•,nbsp:⚛
set list
set lazyredraw
set matchtime=3
set splitbelow
set splitright
set autowrite
set autoread
set shiftround
set title
set linebreak
set noautochdir

let mapleader = " "

" }}}

" Less basic options ------------------------------------------------------ {{{

" iTerm2 is currently slow as balls at rendering the nice unicode lines, so for
" now I'll just use ASCII pipes.  They're ugly but at least I won't want to kill
" myself when trying to move around a file.
set fillchars=diff:⣿,vert:│
set fillchars=diff:⣿,vert:\|

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"

" Better Completion
set complete=.,w,b,u,t
set completeopt=longest,menuone,preview

" stops showing trailing space in insert mode
augroup trailing
    au!
    au InsertEnter * :set listchars-=trail:•
    au InsertLeave * :set listchars+=trail:•
augroup END

" }}}

" Wildmenu completion {{{

set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit

set wildignore+=*.luac                           " Lua byte code

set wildignore+=*.pyc                            " Python byte code

set wildignore+=*.orig                           " Merge resolution files

" Clojure/Leiningen
set wildignore+=classes
set wildignore+=lib

" }}}

" Tabs, spaces, wrapping {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set wrap
set formatoptions=qrn1j

" }}}

" Backups ----------------------------------------------------------------- {{{

set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.

set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}

" Some key maps ----------------------------------------------------------- {{{

nnoremap Q gqip
vnoremap Q gq

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc>^mwgk:silent! s/\v +$//<cr>:noh<cr>`w

" Join an entire paragraph.
nnoremap <leader>J mzvipJ`z

" sudo :w
cnoremap w!! w !sudo tee % >/dev/null

nnoremap <F6> :set paste!<cr>

nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

inoremap jk <esc>
nnoremap <leader><leader> <c-^>
nnoremap <silent> <leader>1 :redraw!<CR>

" }}}

" Searching and movement -------------------------------------------------- {{{

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault

set scrolloff=3
set sidescroll=1
set sidescrolloff=10

set virtualedit+=block

noremap <silent> <leader>, :noh<cr>:call clearmatches()<cr>

runtime macros/matchit.vim
map <tab> %
silent! unmap [%
silent! unmap ]%

" Jumping to tags.
"
" Basically, <c-]> jumps to tags (like normal) and <c-\> opens the tag in a new
" split instead.
"
" Both of them will align the destination line to the upper middle part of the
" screen.  Both will pulse the cursor line so you can see where the hell you
" are.  <c-\> will also fold everything in the buffer and then unfold just
" enough for you to see the destination line.
function! JumpToTag()
    execute "normal! \<c-]>mzzvzz15\<c-e>"
    execute "keepjumps normal! `z"
    Pulse
endfunction
function! JumpToTagInSplit()
    execute "normal! \<c-w>v\<c-]>mzzMzvzz15\<c-e>"
    execute "keepjumps normal! `z"
    Pulse
endfunction
nnoremap <c-]> :silent! call JumpToTag()<cr>
nnoremap <c-\> :silent! call JumpToTagInSplit()<cr>

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Heresy
inoremap <c-a> <esc>I
inoremap <c-e> <esc>A
cnoremap <c-a> <home>
cnoremap <c-e> <end>

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap <silent> <Leader>- :split<CR>
noremap <silent> <Leader><bar> :vsplit<CR>

" }}}

" Plugin settings -------------------------------------------------------- {{{
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': [],
                            \ 'passive_filetypes': ['css', 'scss', 'sass'] }

let g:syntastic_php_phpcs_args           = "--standard=PSR2"
let g:syntastic_check_on_open            = 1
let g:syntastic_debug_file               = '~/.syntastic.log'
let g:syntastic_always_populate_loc_list = 1

let g:ycm_auto_trigger = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:netrw_cursor          = 0
let b:netrw_lastfile        = 1
let g:netrw_use_errorwindow = 0

let g:airline_powerline_fonts = 1

" Tagbar
map <C-k><C-v> :TagbarToggle<CR>
map <leader>v :TagbarOpen fjc<CR>:TagbarShowTag<CR>
let g:tagbar_autofocus = 1

" Use AG (silver searcher) over anything else
if executable('ag')
    " Use Ag over Grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects
    " .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

nnoremap <silent> <leader>t :call VimuxRunLastCommand()<CR>

" }}}

" Languages --------------------------------------------------------------- {{{

" For all text files set 'textwidth' to 78 characters.
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.adoc set filetype=asciidoc

autocmd BufNewFile,BufRead *.json set filetype=javascript

autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
autocmd BufNewFile,BufReadPost *.yml,*.yaml setl shiftwidth=2 expandtab

autocmd FileType text setlocal textwidth=78

" don't make stupid spelling mistakes in commit messages
au BufNewFile,BufRead COMMIT_EDITMSG set spell

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

let g:go_fmt_fail_silently = 0
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['gofmt', 'go', 'govet', 'gotype', 'golint']

" Syntax highlighting
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Cursor position
" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

" }}}

" Custom functions --------------------------------------------------------- {{{

" }}}

" Color stuff ---------------------------------------------------------- {{{

"let &t_Co=256
"let base16colorspace=256
"colorscheme base16-google
"set background=light
let g:airline_theme = 'understated'
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'component': {
      \     'readonly': '%{&readonly?"":""}',
      \     'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}'
      \ },
      \ 'component_visible_condition': {
      \     'readonly': '(&filetype!="help"&& &readonly)',
      \     'modified': '(&filetype!="help"&&(&modified||!&modifiable))'
      \ },
      \ 'component_function': {
      \     'fugitive': 'FugitiveStatus',
      \     'filename': 'MyFilename',
      \     'fileformat': 'MyFileformat',
      \     'filetype': 'MyFiletype',
      \     'fileencoding': 'MyFileencoding',
      \     'mode': 'MyMode',
      \     'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \     'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ } }

augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost * call s:syntastic()
augroup END

function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction

function! MyModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? g:lightline.fname :
                \ fname =~ '__Gundo' ? '' :
                \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
                \ &ft == 'unite' ? unite#get_status_string() :
                \ &ft == 'vimshell' ? vimshell#get_status_string() :
                \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ ('' != fname ? fname : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
                \ fname == '__Gundo__' ? 'Gundo' :
                \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
                \ &ft == 'unite' ? 'Unite' :
                \ &ft == 'vimfiler' ? 'VimFiler' :
                \ &ft == 'vimshell' ? 'VimShell' :
                \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction


function! FugitiveStatus()
    try
        if expand('%:t') !~? 'Tagbar\|Gundo' && &ft !~? 'vimfiler' && exists('*fugitive#head')
            let mark = ''  " edit here for cool mark
            let _ = fugitive#head()
            return strlen(_) ? mark._ : ''
        endif
    catch

    endtry

    return ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction

" }}}

"" Local config (for OS or host-specific stuff)
if filereadable(".vimrc.local")
    source .vimrc.local
endif
