" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Nov 16
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"CY setting
set nu
"colo koehler
colo windrg
set laststatus=2
set statusline=%h%F%m%r%=[%l:%c(%p%%)]	

" CY : highlighting that moves with the cursor
" its colour need to be improved 
"augroup CursorLine
	"au!
	"au VimEnter,WinEnter,BufWinEnter + setlocal cursorline
	"au WinLeave * setlocal nocursorline
"augroup END
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
set cursorline



" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Powerline
set encoding=utf-8 "Necessary to show Unicode glyphs
set t_Co=256
let g:Powerline_cache_dir = '/tmp'


" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

"===================== CY ===================== 
"set ignorecase
"ctags
"set tags=/home/cysh/ws/tagtest/linux-2.6.32/tags
"set tags=$CTAGS_DB

let mapleader=","

"cscope
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
"cs add /home/cysh/ws/tagtest/linux-2.6.32/cscope.out /home/cysh/ws/tagtest/linux-2.6.32
"cs add $CSCOPE_DB


"TagList
let Tlist_Inc_Winwidth = 0
let Tlist_Ctags_Cmd = "/usr/bin/ctags"

"================= functions ===================
"split and select
func! Sts()
    let st=expand("<cword>")
    exe "sts ".st
endfunc
nmap ,ts :call Sts()<cr>
 
"split and jump
func! Stj()
    let st=expand("<cword>")
    exe "stj ".st
endfunc
nmap ,tj :call Stj()<cr>

"find this C symbol
func! Css()
    let st=expand("<cword>")
    exe "scs find s ".st
endfunc
nmap ,cs :call Css()<cr>

"find this Definition
func! Csg()
    let st=expand("<cword>")
    exe "scs find g ".st
endfunc
nmap ,cg :call Csg()<cr>
 
"find functions calling this function
func! Csc()
    let st=expand("<cword>")
    exe "scs find c ".st
endfunc
nmap ,cc :call Csc()<cr>
 
"find functions called by this function
func! Csd()
    let st=expand("<cword>")
    exe "scs find d ".st
endfunc
nmap ,cd :call Csd()<cr>

"find this text string
func! Cst()
    let st=expand("<cword>")
    exe "scs find t ".st
endfunc
nmap ,ct :call Csd()<cr>

"find this file 
func! Csf()
    let st=expand("<cword>")
    exe "scs find t ".st
endfunc
nmap ,cf :call Csf()<cr>


"just split!!
func! Split()
    exe "sp"
endfunc
nmap ,ss :call Split()<cr>
 
"just split and open!!
func! SplitOpen()
    exe "sp ."
endfunc
nmap ,se :call SplitOpen()<cr>
 
"just split vertically!!
func! VSplit()
    exe "vs"
endfunc
nmap ,vv :call VSplit()<cr>
 
"just split & openvertically!!
func! VSplitOpen()
    exe "vs ."
endfunc
nmap ,ve :call VSplitOpen()<cr>
 

" 1st fn key block
map <F2> :ConqueGdb<CR>
nnoremap <silent> <F3> :tabn<CR>
map <F4> <C-W><C-W>

" 2nd fn key block
nmap <F5> :call Stj()<CR>
"map <F6> :q!<CR>
map <F7> :res+1<CR>
map <F8> :res-1<CR>


"3rd fn key block
"TagList
nnoremap <silent> <F9> :TlistToggle<CR>
" >>> how to toggle auto-completion ??
"Conque
let g:ConqueTerm_StartMessages=0
"map <F12> :ConqueTermVSplit bash<CR>
map <F12> :q!<CR>

"no map for reserved to toggle autocp!!!!!

" easier moving of code blocks
vnoremap < <gv " better indentation
vnoremap > >gv " better indentation

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

" how to toggle auto-completion ??

"tab
map <C-O>	:tabe ./<CR>
map <C-N>	:tabnew<CR>

" ConqueGdb
let g:ConqueGdb_GdbExe = '/home/cy13shin/bin/abin/agdb'

" DirDiff
let g:DirDiffExcludes = "CVS,*.class,*.o,*.cmd,*.swp,*.jar,vmlinux,*.dex,*.out,tags,cscope.files,.git"

" diff colors
"highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
"highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
"highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
"highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta
highlight! link DiffText MatchParen

"listchars
"shortcut to rapidly toggle `set list`
"nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
