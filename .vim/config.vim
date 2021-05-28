" colors
set t_Co=256
let g:rehash256 = 1
autocmd vimenter * nested colorscheme gruvbox
" Remove timeout after pressing escape
set timeoutlen=1000 ttimeoutlen=0
set background=dark

" Get rid of showing mode, as it's shown by the lightline plugin
set noshowmode

" show line numbers
set number

" indentation
set smartindent
set autoindent
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

" show tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" start searching the moment I start typing a search
set incsearch
" highligh searches
set hlsearch

" Draw a line at columns 80 and 100
set colorcolumn=80,100

" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on


" Quick session bindings.
set sessionoptions-=options
" Keymappings
nmap <F3> :GitGutterToggle<CR>
" switch to last buffer you were in with F4
nmap <F4> :b#<CR>
" buffer switching with F5, number
nmap <F5> :buffers<CR>:buffer<Space>
nmap <F7> :mksession! .quicksave.vim<CR>
nmap <F8> :source .quicksave.vim<CR>

" Inserting newlines without insert mode
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k

" gitgutter setup
let g:gitgutter_enabled = 0
let g:gitgutter_realtime = 1


" status line goodness

hi User1 ctermfg=red

set laststatus=2

set modelines=0
set nomodeline

" ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_show_hidden = 1
let g:ctrlp_open_new_file = 'v'
