set nocompatible
set nowrap
set number
set noswapfile
set syntax=enable
set termguicolors
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set mouse=a

set background=dark
highlight Comment ctermfg=grey
highlight Normal guifg=#d4d4d4 guibg=#1e1e1e
highlight NonText guifg=#d4d4d4
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

nnoremap <C-j> :vsplit +terminal<CR>
tnoremap <C-k> <C-\><C-n>

let $FZF_DEFAULT_OPTS="--ansi --preview='less {}' --layout reverse"
