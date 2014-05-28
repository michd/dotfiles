" colors
set t_Co=256
let g:molokai_original = 1
let g:rehash256 = 1
colorscheme molokai

" show line numbers
set number

" indentation
set smartindent
set autoindent
set expandtab
set softtabstop=2
set tabstop=2
set shiftwidth=2

" show tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" start searching the moment I start typing a search
set incsearch
" highligh searches
set hlsearch

" Draw a line at column 80
set colorcolumn=80

" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on


" Quick session bindings.
set sessionoptions-=options
" Keymappings
nmap <F3> :GitGutterToggle<CR>
nmap <F7> :mksession! .quicksave.vim<CR>
nmap <F8> :source .quicksave.vim<CR>

" gitgutter setup
let g:gitgutter_enabled = 0
let g:gitgutter_realtime = 1


" status line goodness

hi User1 ctermfg=red

set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=%h      "help file flag
set statusline+=\ %1*%m%*\   "modified flag
set statusline+=%r      "read only flag
set statusline+=\ %y\       "filetype
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
