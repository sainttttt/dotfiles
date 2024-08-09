autocmd! bufwritepost init.vim source ~/.config/nvim/init.vim
let mapleader = "`"

""""""""""""""""""""""""""""
" motion
""""""""""""""""""""""""""""
" undo stuff
"
" remember to set undo/redo stuff in HighlightUndo plugin
" setup bindings as well
nn <C-u> <nop>
nn u <Nop>
nn U <Nop>
nn e u
nn E <C-r>

nn <C-n> <nop>
nn <C-p> <nop>

nn aq <nop>

nn aww yi'
nn awe yi"
nn awr yi(
nn awt yi[

nn aw <nop>
nn awW ya'
nn awE ya"
nn awR ya(
nn awT ya[


nn <M-H> 0^
nn <M-L> $


nm ac yw

" xn q $%
xn Q %
xn q %
nn q %

nn ch "_ci'
nn cj "_ci"
nn ck "_ci(
nn cl "_ci[

nn ah yi'
nn aj yi"
nn ak yi(
nn al yi[


nn ag f
nn t b

nn de db
nn ce cb

nn R yy
nn W y$
xn W y

nn <Left> <C-o>
nn <Right> <C-i>

nn 4 $
xn 4 $

nn 1 0
map 3 #

nm cx c<Plug>CamelCaseMotion_w
map ds d<Plug>CamelCaseMotion_w
nm <m-w> <Plug>CamelCaseMotion_w

" map b <Nop>


" visual search replace
xn s :s#
xm S s

nnoremap <C-p> <C-i>

nmap <M-b> <Nop>
" "nnoremap <Tab> n
" nnoremap M ?

" nn <silent> norm! n

cnoremap <Tab> <CR>
 nnoremap <S-Tab> N

set maxmempattern=5000

set clipboard+=unnamedplus

nnoremap <CR> :
vnoremap <CR> :

nn m J

set conceallevel=0
set viewoptions-=options
set foldopen-=hor foldopen-=search
set nofoldenable

" neovide
cnoremap <d-v> <d-r>+
vmap <d-c> "+y
nmap <d-v> "+p
inoremap <d-v> <c-r>+
cnoremap <d-v> <c-r>+
inoremap <d-r> <c-v>
nnoremap <D-v> "+p
nnoremap <D-o> <C-o>
nnoremap <D-p> <C-i>
nnoremap <D-a> <C-a>
map <silent> <D-t> :tabnew<CR>
map <silent> <D-w> :close<CR>
map <silent> <D-{> :tabprevious<CR>
map <silent> <D-}> :tabnext<CR>

" autocmd BufEnter * call system("tmux rename-window " . expand("%:t"))
" autocmd VimLeave * call system("tmux rename-window zsh")
autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
set title

" nvim-surround stuff
" map a' ysiw'
" map a" ysiw"
" map va ysa
" map v( ysiw(
" map v) ysiw)
" map v[ ysiw[
" map v* ysiw*

vnoremap / <esc>/\%V
" set guicursor=n-v-c-i:block
vnoremap <Space> =
set nocompatible
set hidden
set autoread
filetype on
filetype plugin on
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

" select function textobject
nm ar vafo
nm ae vaIo

nmap ge <leader>ff
""""""""""""""""""""""

nnoremap Q: q:

imap <M-t> †

" indenting -------------------------
vnoremap < <gv
vnoremap > >gv

nn <C-u> <<
xn <C-u> <gv
xn <D-U> <gv
nn <D-U> <<
ino <C-u> <Space><BS><Esc><<A
ino <D-U> <Space><BS><Esc><<A

nn <c-p> <nop>
nn <c-y> <nop>
nn <c-o> <nop>

nn <M-o> <nop>
nn <M-A> >>
nn <M-A> >>
xn <M-A> >gv
xn <M-A> >gv
ino <M-A> <Space><BS><Esc>>>A
ino <M-A> <Space><BS><Esc>>>A


" -------------------------------------

map gb i*<esc>f<space>i*<esc>
map gv i_<esc>f<space>i_<esc>

set noshowmode

autocmd CursorHold * echon ''

set fdo-=search

nnoremap <c-p> <c-i>

nn z <Nop>

" marks

" nmap <leader>m m

nnoremap <leader>1 mQ
nnoremap <leader>2 mW
nnoremap <leader>3 mE
nnoremap <leader>4 mR

map <M-!> zQ
map <M-@> zW
map <M-#> zE
map <M-$> zR

nnoremap <leader>m mM
nnoremap <leader>n mN
nnoremap <leader>b mB
nnoremap <leader>v mV

map zm zM
map zn zN
map zb zB
map zv zV

autocmd FileType lua setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*--'

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
" nnoremap <silent> WQ :up<CR>:close!<CR>
nnoremap <silent> ZZ :qa!<CR>
nnoremap <silent> MM :qa!<CR>
nnoremap <silent> BB :qa!<CR>

autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>
autocmd Filetype qf map <buffer> <Space> <CR>

" --------------------------------------------------

nnoremap J 15j
nnoremap K 15k

nnoremap <silent>L :MoveCursor<cr>
nnoremap <silent>H :MoveCursor b<cr>


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

nnoremap <D-h> <C-w>h
nnoremap <D-l> <C-w>l

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


" abbreviations ---------------------------------

iab cl console.log
iab pr print

""""""""""""""""""""""""""""""""""""

nnoremap <silent> ) :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> ( :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

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
" nnoremap <silent> <leader>e :TroubleToggle<cr>


function! s:GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleQuickfixList()
  for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      cclose
      return
    endif
  endfor
  let winnr = winnr()
  if exists("g:toggle_list_copen_command")
    exec(g:toggle_list_copen_command)
  else
    bot copen
  endif
  if winnr() != winnr
    wincmd p
  endif
endfunction

nnoremap <silent> <C-n> :call ToggleQuickfixList()<cr>

" nnoremap <C-s> :cp<CR>
" nnoremap <C-d> :cn<CR>

" --------------------------------------------------
" tex ----------------------------------------------


" --------------------------------------------------
" appearance ---------------------------------------

" line cursor in insert mode, block in command mode
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"

set guifont=Ac437_ToshibaSat_9x14:h33

set background=dark
set wildmode=longest,list,full
set wildmenu
set gcr=n:blinkon0

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
  elseif exists("g:restore")
    exec "normal! \<Cmd>lua require('mini.sessions').read('main')\<CR>"
  endif
endfunction

autocmd VimEnter * call StartCmd()
autocmd VimLeave * lua saveSessionQuit()

" map <M-n> Tab
" map <M-N> <S-Tab>

nmap <leader>ee <cmd>Lazy reload plugin yoke.vim<CR>

if !exists('g:neovide')
  hi Normal guibg=None
endif


if exists('g:neovide')
  exec 'cd /Users/saint/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Katarina'
  edit GEN\ TODO.md
endif

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
lua require('init')

set cursorline

augroup yank_text_highlight
  autocmd!
  autocmd InsertEnter * hi! link CursorLine CursorLineEdit
  autocmd InsertLeave * hi! link CursorLine CursorLineMain
  autocmd TextYankPost * hi! link CursorLine YankText | call timer_start(200, { tid -> execute('hi! link CursorLine CursorLineMain')})
augroup END
