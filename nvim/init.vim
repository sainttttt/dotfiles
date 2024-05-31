set clipboard+=unnamedplus
let mapleader = ","

nnoremap <CR> :
vnoremap <CR> :

nnoremap m J
xnoremap m :

set conceallevel=0

set viewoptions-=options

augroup remember_folds
  autocmd!
  au BufWinLeave ?* mkview 2
  au BufWinEnter ?* silent! call timer_start(200, { tid -> execute('!silent loadview 2')})
augroup END

" neovide
cnoremap <d-v> <d-r>+
vmap <d-c> "+y
nmap <d-v> "+p
inoremap <d-v> <c-r>+
cnoremap <d-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <d-r> <c-v>
nnoremap <D-v> "+p
nnoremap <D-o> <C-o>
nnoremap <D-p> <C-i>
nnoremap <D-a> <C-a>
map <silent> <D-t> :tabnew<CR>
map <silent> <D-w> :close<CR>
map <silent> <D-{> :tabprevious<CR>
map <silent> <D-}> :tabnext<CR>

nnoremap 22 zz



""""""""""""""""""""""""""""
" motion
""""""""""""""""""""""""""""
" nn u <Nop>
nn <C-u> u
nn U <Nop>
nn <C-n> <nop>

" xn q $%
xn Q %
xn q %
nn q %

nn ag f
nn e b
nn de db
nn ce cb
nn E y$
nn W Y
xn W y

" nn w <Nop>
" nn b <Nop>
" nn dw dw
" nn cw cw

" nn <Left> 0w
" nn <Right> $
nn <M-H> 0w
nn <M-L> $

nn 4 $
map 3 #


nm cx c<Plug>CamelCaseMotion_w
map ds d<Plug>CamelCaseMotion_w
nm <m-w> <Plug>CamelCaseMotion_w
nm <m-e> <Plug>CamelCaseMotion_b
" map b <Nop>


" visual search replace
xn s :s#
xm S s


nnoremap <C-p> <C-i>

nmap <M-b> <Nop>
nnoremap <Tab> n
nnoremap M ?

cnoremap <Tab> <CR>
nnoremap <S-Tab> N

set maxmempattern=5000

" nvim-surround stuff
" map a' ysiw'
" map a" ysiw"
" map va ysa
" map v( ysiw(
" map v) ysiw)
" map v[ ysiw[
" map v* ysiw*

vnoremap / <esc>/\%V

set guicursor=n-v-c-i:block
vnoremap <Space> =
set nocompatible
set hidden
set autoread
filetype on
filetype plugin on
set nofoldenable
set ignorecase
set smartcase
set backspace=2

nnoremap ` <esc>

let g:netrw_silent = 1
set ph=9

nnoremap 8 :
nnoremap 9 0

nnoremap aa a

""""""""""""""""""""""
" todo: clean this up ""
nmap at <leader>mt

nmap ar <leader>rr

nmap gf <leader>fg
nmap ge <leader>ff
""""""""""""""""""""""

nnoremap Q: q:

imap <M-t> †

" indenting -------------------------
vnoremap < <gv
vnoremap > >gv

nn <M-&> <<
xn <M-&> <gv
xn <D-U> <gv
nn <D-U> <<
ino <M-&> <Esc><<i
ino <D-U> <Esc><<i

nn <M-o> <nop>

nn <M-*> >>
nn <D-I> >>
xn <D-I> >gv
xn <M-*> >gv
ino <M-*> <Esc>>>i
ino <D-I> <Esc>>>i


" -------------------------------------


map gb i*<esc>f<space>i*<esc>
map gv i_<esc>f<space>i_<esc>

set foldopen-=hor
set noshowmode

autocmd CursorHold * echon ''



" nm e Y
" xm e y
" nm E y$


set fdo-=search

nnoremap <c-p> <c-i>



nnoremap 2 z
nnoremap z `

" marks
"
" nmap <leader>m m
nnoremap <leader>m mM
nnoremap <leader>n mN
nnoremap <leader>b mB
nnoremap <leader>v mV

map zm zM
map zn zN
map zb zB
map zv zV

map <silent> <M-r> :call feedkeys(,rr<CR>)<CR>
" nnoremap <silent> <Leader>w :w<CR>:Runtime<CR>
nnoremap <silent> <Leader>bd :Bdelete hidden<CR>

nnoremap <silent> <Leader>e :Messages<CR>
" nnoremap <silent> <Leader>ss :lua MiniSessions.read()<CR>
" nnoremap <silent> WW :close!<CR>
" nnoremap <silent> <M-W> :close!<CR>

nnoremap <silent> <M-W> :call undoquit#SaveWindowQuitHistory()<cr>:close!<CR>
nnoremap <silent> <M-z> :Undoquit<CR>
" unmap S
" nnoremap <silent> s <esc>
nnoremap <silent> s :up<CR>
nnoremap <silent> <M-s> :up<CR>
inoremap <silent> <M-s> <esc>:w<CR>
" nnoremap <silent> WQ :up<CR>:close!<CR>
nnoremap <silent> QA :qa!<CR>

autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
autocmd Filetype qf map <buffer> <Space> <CR>

" --------------------------------------------------

nnoremap J 15j
nnoremap K 15k

nnoremap <silent>L :MoveCursor<cr>
nnoremap <silent>H :MoveCursor b<cr>

" grep search
nm <silent><M-i> <C-u>
nm <M-u> <Nop>

nnoremap <silent><M-down> :MoveCursor<cr>
nnoremap <silent><M-up> : MoveCursor b<cr>

xnoremap <silent>L :<C-u> VMoveCursor<cr>

xnoremap <silent>H :<C-u> VMoveCursor b<cr>

xnoremap <silent>J :<C-u> VMoveCursor<cr>
xnoremap <silent>K :<C-u> VMoveCursor b<cr>


" this needs to be map and no noremap for macros/matchit.vim to work

" splits
nnoremap <C-J> <C-w>j
nnoremap <C-J> <esc><C-w>j

nnoremap <C-T> <C-w>l
inoremap <C-T> <esc><C-w>l

map <C-K> <C-w>k

nnoremap <C-H> <C-w>h
nnoremap <C-L> <C-w>l

nnoremap <D-h> <C-w>h
nnoremap <D-l> <C-w>l

inoremap <C-h> <Esc><C-w>h
inoremap <C-l> <Esc><C-w>l

nnoremap <M-.> <C-w>L
nnoremap <M-,> <C-w>H
" nnoremap <M-m> <C-w>J

" --------------------------------------------------
" delete and yank ----------------------------------
" --------------------------------------------------

nnoremap dd "_dd
nnoremap d "_d
nnoremap x "_x
vnoremap x "_x

vnoremap X x

nnoremap c "_c
nnoremap cc "_cc

nnoremap C "_C
nnoremap D Ydd

" needed for neovim
nnoremap Y yy
vnoremap Y yy

nnoremap <M-y> "pyy
nnoremap <M-p> "pp

" Don't touch unnamed register when pasting over visual selection
xnoremap <expr> p 'pgv"' . v:register . 'y'


" --------------------------------------------------
" --------------------------------------------------

set updatetime=750

" trigger `autoread` when files changes on disk
set autoread

let g:searchx = {}

let g:context_enabled = 0
let g:context_border_char = ''
let g:context_highlight_normal = 'Context'
let g:context_highlight_tag = '<hide>'

" Auto jump if the recent input matches to any marker.
let g:searchx.auto_accept = v:true

" The scrolloff value for moving to next/prev.
let g:searchx.scrolloff = &scrolloff

" To enable scrolling animation.
let g:searchx.scrolltime = 1

" To enable auto nohlsearch after cursor is moved
let g:searchx.nohlsearch = {}
let g:searchx.nohlsearch.jump = v:true

" Marker characters.
let g:searchx.markers = split('FDSREWVCXAQZUIOPHJKLBNMTYGVB', '.\zs')

" Convert search pattern.
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction


" general settings ---------------------------------
"

iab cl console.log
iab pr print

" autocmd BufRead * DetectIndent

" reload vimrc on save
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim


nnoremap <silent> ) :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> ( :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

let g:go_doc_keywordprg_enabled = 0

set cursorline

let g:vimtex_quickfix_latexlog = {
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \}
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_latexmk = {'callback' : 0}

com! FormatJSON %!python -m json.tool

" noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
  endif
endfunction


" --------------------------------------------------------------------
" quickfix -----------------------------------------------------------
"
nnoremap <silent> <C-e> :TroubleToggle<CR>
nnoremap <silent> <leader>e :TroubleToggle<cr>

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <F2> :call ToggleQuickFix()<cr>

" nnoremap <C-s> :cp<CR>
" nnoremap <C-d> :cn<CR>

" --------------------------------------------------
" tex ----------------------------------------------


" --------------------------------------------------
" appearance ---------------------------------------

" line cursor in insert mode, block in command mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set guifont=Ac437_ToshibaSat_9x14:h33

set background=dark
set wildmode=longest,list,full
set wildmenu
set gcr=n:blinkon0

noremap tt :vsp<CR>

"" edit vimrc
"" todo: open in dedicated split for config stuff
noremap <Leader>vv :vsp ~/.config/nvim/init.vim<CR>
noremap <Leader>va :vsp ~/.config/nvim/lua/init.lua<CR>
noremap <Leader>vz :vsp ~/.config/nvim/lua/plugins/init.lua<CR>
" noremap <Leader>vc :vsp ~/.config/nvim/lua/plugins/<CR>
" noremap <Leader>vx :vsp ~/.config/nvim/lua/<CR>

noremap <Leader>xr :!chmod +x % <CR><CR>

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"autocomplete brace
inoremap {<CR>  {<CR>}<Esc>O

" inoremap ({<CR>  ({<CR>});<Esc>O

" vimrc
set hlsearch


nmap <silent> <Space> :nohlsearch<CR>
" set clipboard=unnamed

"""""""""""""""""""
" syntax
""""""""""""""""""
syntax on
let g:jsx_ext_required = 0
au BufRead,BufNewFile *.py set filetype=python

" nnoremap <C-u> u
nnoremap <C-q> q

" defaults
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set shiftround
set showmatch
set incsearch
set cindent
set ruler
set laststatus=2
set number
set rnu


function! TexSetup()
  setlocal wrap linebreak nolist
  set virtualedit=
  setlocal display+=lastline
  noremap  <buffer> <silent> k gk
  noremap  <buffer> <silent> j gj
  noremap  <buffer> <silent> 0 g0
  noremap  <buffer> <silent> $ g$
  map <Leader>lc <plug>(vimtex-compile-ss)
  map <Leader>lv <plug>(vimtex-view)
  map <Leader>lC <plug>(vimtex-clean)
endfunction


autocmd FileType python noremap <Leader>p oimport pdb; pdb.set_trace()<Esc>
" autocmd FileType python noremap <Leader>z ggi#!/usr/bin/env python<Esc><C-o>

" noremap <Leader>z ggO#!/usr/bin/env python<Esc><C-o>:w<CR>

autocmd Filetype tex call TexSetup()

autocmd FileType python set ts=4|set shiftwidth=4

"""""""""""""""""""""""""""""""""""""""""""
" COMMENTING
""""""""""""""""""""""""""""""""""""""""""
nmap av gcc
vmap av gcc
vmap f gc
vmap F gc

"""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""

" filetype indent on

autocmd FileType c,cpp,java,javascript,php autocmd BufWritePre <buffer> :retab

" select function def
"map Q ?function<CR>V/{<CR>%
" map Q va{V
" select brace
" map W 0Vf{%
" select func call
"map E 0v/(<CR>%

map! <Nul> <C-c>
vmap <Nul> <C-c>
smap <Nul> <C-c>
cnoremap <Nul> <C-c>
noremap T y$

set mouse=a
set nobackup
set nowritebackup
set noswapfile


fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("W","w")
call SetupCommandAlias("Q","q")
call SetupCommandAlias("Wq","wq")
call SetupCommandAlias("Qa","qa")
call SetupCommandAlias("ack","Ack")
call SetupCommandAlias("h","vert h")
call SetupCommandAlias("H","vert h")
call SetupCommandAlias("vh","vert h")
call SetupCommandAlias("Vh","vert h")
call SetupCommandAlias("Vsp","vsp")

function! RunMacro(macro_reg)
  echo a:macro_reg
  let s:mylist = ""
  let s:mylist = getreg(a:macro_reg)
  for s:item in split(s:mylist, '\zs')
    call feedkeys(s:item, 't')
  endfor

endfunction

" nmap @ :call CallMacro()<CR>

function! s:getchar()
  let c = getchar()
  if c =~ '^\d\+$'
    let c = nr2char(c)
  endif
  return c
endfunction

function! CallMacro()
   "execute "normal! d".input("enter motion: ")
   "let @/=@"
   "startinsert
  "echo "(InteractiveWindow) TYPE: h,j,k,l to resize or a for auto resize"
  let macro_reg = ""
  let macro_reg = s:getchar()
  echo l:macro_reg
  call RunMacro(l:macro_reg)

"  let l:mylist = getreg(l:macro_reg)
"  for l:item in split(l:mylist, '\zs')
"    call feedkeys(l:item, 't')
"  endfor

endfunction

autocmd BufEnter,BufWinEnter,WinEnter * setlocal winhl=Search:LocalSearch,IncSearch:LocalSearch

highlight Conceal ctermbg=237 guibg=NONE guifg=DarkGrey term=NONE
" hi IncSearch cterm=NONE ctermfg=yellow ctermbg=red
" hi CurSearch cterm=NONE ctermfg=yellow ctermbg=red

set fillchars=stl:─,stlnc:─

set termguicolors
lua require('init')
let g:hybrid_use_Xresources = 1
colorscheme flesh-and-blood

augroup autocom
    autocmd!
    "executes the command on quit
     autocmd VimLeave *.swift !killall xbase xbase-sourcekit-helper

    ""execute the command on write
    "autocmd BufWritePost,FileWritePost *.cpp !your_commad
augroup END

function! StartCmd()
  if exists("g:startcmd")
    exec "normal ". g:startcmd
  endif
endfunction

autocmd VimEnter * call StartCmd()

map <M-n> Tab
map <M-N> <S-Tab>

nmap <leader>re <cmd>Lazy reload plugin yoke.vim<CR>

if !exists('g:neovide')
  hi Normal guibg=None
endif

if exists('g:neovide')
  exec 'cd /Users/saint/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Katarina'
  edit GEN\ TODO.md
endif
