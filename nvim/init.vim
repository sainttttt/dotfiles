nnoremap <M-J> ]m
nnoremap <M-K> [m

set clipboard+=unnamedplus

cnoremap <d-v> <d-r>+
" system clipboard
nmap <d-c> "+y
vmap <d-c> "+y
nmap <d-v> "+p
inoremap <d-v> <c-r>+
cnoremap <d-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <d-r> <c-v>
nnoremap <D-v> "+p


map <Tab> <esc>
if exists('g:neovide')
    exec 'cd ~/code/tmp"'
endif

map <silent> <D-t> :tabnew<CR>
map <silent> <D-w> :close<CR>

map <silent> <D-[> :tabprevious<CR>
map <silent> <D-]> :tabnext<CR>

" nvim-surround stuff
map v' ysiw'
map v" ysiw"
map va ysa
map v( ysiw(
map v) ysiw)
map v[ ysiw[
map v* ysiw*
map v8 ysiw*

vnoremap / <esc>/\%V

set guicursor=n-v-c-i:block
vnoremap <Space> =
set nocompatible
set hidden
set autoread
filetype on
filetype plugin on
" set nofoldenable
set ignorecase
set smartcase
set backspace=2
let mapleader = ","
nmap ' ,
nnoremap ` <esc>
let maplocalleader = ",,"
let g:netrw_silent = 1
set ph=9
nnoremap 8 :

nnoremap aa a
nmap af <Tab>

nmap gf <leader>fg
nmap ge <leader>ff
nmap <C-u> <leader>fw
nmap <leader>t <leader>mt
nnoremap Q: q:


imap <M-t> †

vnoremap < <gv
vnoremap > >gv

map gb i*<esc>f<space>i*<esc>
map gv i_<esc>f<space>i_<esc>

set foldopen-=hor
set noshowmode

autocmd CursorHold * echon ''


map <silent> e <Plug>CamelCaseMotion_w


set fdo-=search

nnoremap <c-p> <c-i>

"nnoremap <leader>z z

map 4 $

" augroup remember_folds
"   autocmd!
"   au BufWinLeave ?* mkview 1
"   au BufRead ?* silent! loadview 1
" augroup END

nnoremap 2 `

map mm mM
map mn mN
map mb mB
map mv mV

map 2m 2M
map 2n 2N
map 2b 2B
map 2v 2V

" noremap ;; ``
" nnoremap zz za
nnoremap B za

" nnoremap q %
" vnoremap q %
map q %

map <silent> <M-r> :call feedkeys(,rr<CR>)<CR>
" nnoremap <silent> <Leader>w :w<CR>:Runtime<CR>
nnoremap <silent> <Leader>ww :up<CR>:Runtime<CR>
nnoremap <silent> <Leader>bd :Bdelete hidden<CR>

" map <silent> W Vaio

nnoremap <silent> <Leader>e :Messages<CR>
" nnoremap <silent> <Leader>ss :lua MiniSessions.read()<CR>
nnoremap <silent> <Leader>s :up<CR>
" nnoremap <silent> WW :close!<CR>
nnoremap <silent> <M-w> :close!<CR>
nnoremap <silent> <M-z> :Undoquit<CR>
" unmap S
nnoremap <silent> S :up<CR>
" nnoremap <silent> s <esc>
nnoremap <silent> s :up<CR>
nnoremap <silent> <M-s> :up<CR>
inoremap <silent> <M-s> <esc>:w<CR>
" nnoremap <silent> WQ :up<CR>:close!<CR>
nnoremap <silent> QA :qa!<CR>


autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

nnoremap <C-a> :NvimTreeFindFile<CR>

" --------------------------------------------------
" navigation ---------------------------------------

" This is for debugging, shows the syntax type under cursor
" nnoremap <leader>mm :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
" \ . synIDattr(synID(line("."),col("."),1),"name") . "> lo<"
" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! CharAtIdx(str, idx) abort
  " Get char at idx from str. Note that this is based on character index
  " instead of the byte index.
  return strcharpart(a:str, a:idx, 1)
endfunction


function! CursorCharIdx() abort
  " A more concise way to get character index under cursor.
  let cursor_byte_idx = col('.')
  if cursor_byte_idx == 1
    return 0
  endif

  let pre_cursor_text = getline('.')[:col('.')-2]
  return strchars(pre_cursor_text)
endfunction

" --------------------------------------------------


" vnoremap J }
" vnoremap K {

nnoremap J 15j
nnoremap K 15k

nnoremap <silent>L :MoveCursor<cr>
" xnoremap <silent>L :<C-u>call VMoveCursor('')<cr>
xnoremap <silent>L :<C-u> VMoveCursor<cr>
xnoremap <silent>J :<C-u> VMoveCursor<cr>
nnoremap <silent>H : MoveCursor b<cr>
" xnoremap <silent>H :<C-u> VMoveCursor('b')<cr>
xnoremap <silent>H :<C-u> VMoveCursor b<cr>
xnoremap <silent>K :<C-u> VMoveCursor b<cr>


noremap <C-n> J

" this needs to be map and no noremap for macros/matchit.vim to work
" nnoremap q %

" splits
map <C-J> <C-w>j
map <C-K> <C-w>k
map <C-h> <C-w>h
nnoremap <M-H> <C-w>h
nnoremap <M-L> <C-w>l
nnoremap <C-H> <C-w>h
nnoremap <C-L> <C-w>l
inoremap <C-h> <Esc><C-w>h
inoremap <C-l> <Esc><C-w>l

" Can't figure out how to map M-hjkl in iTerm for some reason
nnoremap <M-.> <C-w>L
nnoremap <M-,> <C-w>K
nnoremap <M-m> <C-w>J
nnoremap <M-n> <C-w>H

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


" --------------------------------------------------
" --------------------------------------------------

set updatetime=750

"source ~/.local/share/nvim/yoke.vim

" trigger `autoread` when files changes on disk
set autoread
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if !bufexists("[Command Line]") | silent! checktime | endif

" notification after file change
" autocmd FileChangedShellPost *
"   \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None





" Overwrite / and ?.
" nnoremap ? <Cmd>lua searchXBackward()<CR>
" nnoremap / <Cmd>lua searchXForward()<CR>

" xnoremap ? <Cmd>lua searchXBackward()<CR>
" xnoremap / <Cmd>lua searchXForward()<CR>
" cnoremap ; <Cmd>call searchx#select()<CR>

" " Move to next/prev match.
" nnoremap N <Cmd>call searchx#prev_dir()<CR>
" nnoremap n <Cmd>call searchx#next_dir()<CR>
" xnoremap N <Cmd>call searchx#prev_dir()<CR>
" xnoremap n <Cmd>call searchx#next_dir()<CR>

" Clear highlights
" nnoremap <C-l> <Cmd>call searchx#clear()<CR>

let g:searchx = {}

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
let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')

" Convert search pattern.
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction


" general settings ---------------------------------
"
 let s:nimlspexecutable = "/Users/saint/.nimble/bin/nimlsp"
 let g:lsp_log_verbose = 1
 let g:lsp_log_file = expand('/tmp/vim-lsp.log')
 " for asyncomplete.vim log
 let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')

 let g:asyncomplete_auto_popup = 0

 if has('win32')
    let s:nimlspexecutable = "nimlsp.cmd"
    " Windows has no /tmp directory, but has $TEMP environment variable
    let g:lsp_log_file = expand('$TEMP/vim-lsp.log')
    let g:asyncomplete_log_file = expand('$TEMP/asyncomplete.log')
 endif
 if executable(s:nimlspexecutable)
    au User lsp_setup call lsp#register_server({
    \ 'name': 'nimlsp',
    \ 'cmd': {server_info->[s:nimlspexecutable]},
    \ 'whitelist': ['nim'],
    \ })
 endif

" function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ asyncomplete#force_refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"



" " for syntax highlighting on large files
" set redrawtime=10000

set rnu

iab cl console.log
iab pr print



" autocmd BufRead * DetectIndent

" reload vimrc on save
autocmd! bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim

" trying out some html thing (experiment)
nnoremap <Leader>h 0f<a/<esc>f<Space>C><esc>

" nnoremap <Leader>s :filetype detect<Esc>

" GoTo code navigation.
nmap <silent> gd <Plug>(ale_go_to_definition)
nmap <silent> gr <Plug>(ale_find_references)
" nmap <silent> C-] <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)

let g:vim_vue_plugin_config = {
      \'syntax': {
      \   'template': ['html'],
      \   'script': ['javascript'],
      \   'style': ['css'],
      \},
      \'full_syntax': [],
      \'initial_indent': [],
      \'attribute': 0,
      \'keyword': 0,
      \'foldexpr': 0,
      \'debug': 0,
      \}


nnoremap <silent> ) :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> ( :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

nnoremap <silent> <Leader>g :GoldenRatioToggle<CR>

let g:AutoPairs = {'(':')', '[':']', '{':'}'}

" snake to camel case
" :s#_\(\l\)#\u\1#g
"

let g:python_highlight_all = 1
let g:python_highlight_operators = 0
let g:python_highlight_file_headers_as_comments = 1

let g:golden_ratio_exclude_nonmodifiable = 1
let g:golden_ratio_wrap_ignored = 0
let g:golden_ratio#disabled_filetypes = ['fzf', 'qf']


let g:go_doc_keywordprg_enabled = 0

set gfn=Monaco:h19

set cursorline

let g:vimtex_quickfix_latexlog = {
      \ 'overfull' : 0,
      \ 'underfull' : 0,
      \}
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_latexmk = {'callback' : 0}

com! FormatJSON %!python -m json.tool


" Damian Conway's Die Blinkënmatchen: highlight matches
nnoremap <silent> n n:call HLNext(0.1)<cr>
nnoremap <silent> N N:call HLNext(0.1)<cr>

function! HLNext (blinktime)
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

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

" no scrollbars in gvim
set guioptions-=l
set guioptions-=r
set guioptions-=b
" set guifont=Ac437_ACM_VGA_8x16:h29
set guifont=Ac437_ToshibaSat_9x14:h38
set background=dark
set wildmode=longest,list,full
set wildmenu
let g:NERDTreeMinimalMenu=1
set gcr=n:blinkon0

" gvim specific stuff
set guioptions-=T
set novisualbell

"" edit vimrc
noremap <Leader>vv :vsp ~/.config/nvim/init.vim<CR>
noremap <Leader>va :vsp ~/.config/nvim/lua/init.lua<CR>
" noremap <Leader>vc :vsp ~/.config/nvim/lua/plugins/<CR>
noremap <Leader>vz :vsp ~/.config/nvim/lua/plugins/init.lua<CR>
" noremap <Leader>vx :vsp ~/.config/nvim/lua/<CR>

noremap <Leader>xr :!chmod +x % <CR><CR>

set undodir=~/.vim/undodir
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

"autocomplete brace
inoremap {<CR>  {<CR>}<Esc>O
inoremap ({<CR>  ({<CR>});<Esc>O

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
 nmap \ gcc
 vmap \ gc
 nmap \| gcc
 vmap \| gc

"""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""

filetype indent on

" cursorline (makes it slow sometimes)
" set nocursorline

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

" noremap 4 $
" noremap q %

" let loaded_matchparen = 1

" noremap c) f(F(lct)

" map d' di'hxx
" map c' ci ysiw'
" nnoremap " ysiw"

" noremap [ i[<esc>wwhi]<esc>

set mouse=a
set nobackup
set nowritebackup
set noswapfile

set wildignore+=*/node_modules/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|json)$'

" javascript syntax
let g:jsx_ext_required = 0

fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("W","w")
call SetupCommandAlias("Q","q")
" call SetupCommandAlias("q","close")
" call SetupCommandAlias("qq","q")
" call SetupCommandAlias("Qq","q")
" call SetupCommandAlias("QQ","q")
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


""" colorscheme

autocmd BufEnter,BufWinEnter,WinEnter * setlocal winhl=Search:LocalSearch,IncSearch:LocalSearch

highlight Conceal ctermbg=237 guibg=NONE guifg=DarkGrey term=NONE
" hi IncSearch cterm=NONE ctermfg=yellow ctermbg=red
" hi CurSearch cterm=NONE ctermfg=yellow ctermbg=red

set fillchars=stl:─,stlnc:─
" set statusline=%#Search#%m%#LineNr#%F%=%3l:%-2c%=

" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indent_blankline_space_char_blankline = '⋅'
" let g:indentLine_color_term = 234

function! MessageWindow()
  new
  redir => messages_output
  silent messages
  redir END
  silent put=messages_output
endfunction

let g:vindent_motion_OO_prev   = '[=' " jump to prev block of same indent.
let g:vindent_motion_OO_next   = ']=' " jump to next block of same indent.
let g:vindent_motion_more_prev = '[+' " jump to prev line with more indent.
let g:vindent_motion_more_next = ']+' " jump to next line with more indent.
let g:vindent_motion_less_prev = '[-' " jump to prev line with less indent.
let g:vindent_motion_less_next = ']-' " jump to next line with less indent.
let g:vindent_motion_diff_prev = '[;' " jump to prev line with different indent.
let g:vindent_motion_diff_next = '];' " jump to next line with different indent.
let g:vindent_motion_XX_ss     = '[p' " jump to start of the current block scope.
let g:vindent_motion_XX_se     = ']p' " jump to end   of the current block scope.
let g:vindent_object_XX_ii     = 'ii' " select current block.
let g:vindent_object_XX_ai     = 'ai' " select current block + one extra line  at beginning.
let g:vindent_object_XX_aI     = 'aI' " select current block + two extra lines at beginning and end.
let g:vindent_jumps            = 1    " make vindent motion count as a |jump-motion| (works with |jumplist|).


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

