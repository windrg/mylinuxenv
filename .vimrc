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

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
  Plugin 'gmarik/Vundle.vim'

"
" " The following are examples of different formats supported.
" " Keep Plugin commands between vundle#begin/end.
" " plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" " plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" " Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" " git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" " The sparkup vim script is in a subdirectory of this repo called vim.
" " Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " Avoid a name conflict with L9
" Plugin 'user/L9', {'name': 'newL9'}
"
" All of your Plugins must be added before the following line
"
  Plugin 'vim-scripts/AnsiEsc.vim'
  Plugin 'vim-scripts/DirDiff.vim'
  Plugin 'vim-scripts/LogViewer'
  Plugin 'vim-scripts/Logcat-syntax-highlighter'
  "Plugin 'vim-scripts/Mark--Karkat' " not updated on github so determined to use in a old-fashioned way
  Plugin 'vim-scripts/SearchComplete'
  Plugin 'vim-scripts/grep.vim'
  Plugin 'vim-scripts/hexman.vim'
  Plugin 'vim-scripts/mru.vim'
  Plugin 'vim-scripts/prop.vim'
  Plugin 'vim-scripts/python.vim--Vasiliev'
  Plugin 'vim-scripts/taglist.vim' " or tagbar

  Plugin 'tpope/vim-fugitive'
  Plugin 'gregsexton/gitv'
  Plugin 'airblade/vim-gitgutter'

  Plugin 'sjl/gundo.vim'

  Plugin 'xolox/vim-session'
  Plugin 'xolox/vim-misc'

  Plugin 'tpope/vim-unimpaired'

  Plugin 'scrooloose/syntastic'

  Plugin 'bling/vim-airline'

  "Plugin 'clone/vim-cecutil' " ???
  
  Plugin 'Valloric/YouCompleteMe' " use supertab if it's not available on your system.
  	"Plugin 'ervandew/supertab' " use this if YCM is not available 


  Plugin 'lpenz/vimcommander' 

  Plugin 'tomasr/molokai'
  Plugin 'vim-scripts/borland.vim'

call vundle#end()            " requirelid
" " filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line



" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"CY setting
set nu
"colo koehler
"colo windrg
colo molokai
"colo borland
"colo zenburn
"let g:molokai_original=1
"let g:rehash256=1
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
  " windrg temporal off
  "autocmd FileType text setlocal textwidth=78

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
" sometimes this is required on Windows
set fileencodings=euc-kr,utf-8

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
" add any cscope database in current directory
if filereadable("cscope.out")
	cs add cscope.out
" else add the database pointed ot by environment variable
elseif $CSCOPE_DB !=""
	cs add $CSCOPE_DB
endif
"set cscopequickfix=s-,c-,d-,i-,t-,e-,f-
set cscopequickfix=t-,e-
" show msg when any other cscope db added
set cscopeverbose


"TagList
let Tlist_Inc_Winwidth = 0
let Tlist_Ctags_Cmd = "/usr/bin/ctags"

"================= functions ===================
"split and select
func! Sts()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "sts ".st
endfunc
nmap <leader>ts :call Sts()<cr>
 
"split and jump
func! Stj()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "stj ".st
endfunc
nmap <leader>tj :call Stj()<cr>

"find this C symbol
func! Css()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "scs find s ".st
endfunc
nmap <leader>cs :call Css()<cr>
func! VCss()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "vert scs find s ".st
endfunc
nmap <leader>vs :call VCss()<cr>

"find this Definition
func! Csg()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "scs find g ".st
endfunc
nmap <leader>cg :call Csg()<cr>
func! VCsg()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "vert scs find g ".st
endfunc
nmap <leader>vg :call VCsg()<cr>
 
"find functions calling this function
func! Csc()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "scs find c ".st
endfunc
nmap <leader>cc :call Csc()<cr>
func! VCsc()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "vert scs find c ".st
endfunc
nmap <leader>vc :call VCsc()<cr>
 
"find functions called by this function
func! Csd()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "scs find d ".st
endfunc
nmap <leader>cd :call Csd()<cr>
func! VCsd()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "vert scs find d ".st
endfunc
nmap <leader>vd :call VCsd()<cr>


"find this text string
func! Cst()
    let st=expand("<cword>")
    echo 'Finding "'.st.'"'
    exe "Mark ".st
    exe "scs find t ".st
    botright copen
endfunc
nmap <leader>ct :call Cst()<cr>
func! VCst()
    let st=expand("<cword>")
    echo 'Finding "'.st.'"'
    exe "Mark ".st
    exe "vert scs find t ".st
    botright open
endfunc
nmap <leader>vt :call VCst()<cr>

func! s:get_visual_selection()
	"let l=getline("'<")
	"let [lnum1,col1] = getpos("'<")[1:2]
	"let [lnum2,col2] = getpos("'>")[1:2]
	"let lines=getline(lnum1, lnum2)
	"let lines[-1] = lines[-1][: col2 - (&selection =='inclusive' ? 1 : 2)]
	"let lines[0] = lines[0][col1 - 1:]
	"return join(lines,"\n")
	let save_clipboard = &clipboard
	set clipboard= " Avoid clobbering the selection and clipboard registers.
	let save_reg = getreg('"')
	let save_regmode = getregtype('"')
	silent normal! gvy
	let res = getreg('"')
	call setreg('"', save_reg, save_regmode)
	let &clipboard = save_clipboard
	return res
endfunc
func! Cstv()
    let st=s:get_visual_selection()
    echo 'Finding "'.st.'"'
    exe "Mark ".st
    exe "scs find t ".st
    botright copen
endfunc
vnoremap <leader>ct :call Cstv()<cr>
func! VCstv()
    let st=s:get_visual_selection()
    echo 'Finding "'.st.'"'
    exe "Mark ".st
    exe "vert scs find t ".st
    botright copen
endfunc
vnoremap <leader>vt :call VCstv()<cr>

"find this file 
func! Csf()
    let st=expand("<cword>")
    exe "scs find f ".st
    botright copen
endfunc
nmap <leader>cf :call Csf()<cr>
func! VCsf()
    let st=expand("<cword>")
    exe "vert scs find f ".st
    botright copen
endfunc
nmap <leader>vf :call VCsf()<cr>
func! Csfv()
    let st=s:get_visual_selection()
    exe "Mark ".st
    echo 'Finding "'.st.'"'
    exe "scs find f ".st
    botright copen
endfunc
vnoremap <leader>cf :call Csfv()<cr>
func! VCsfv()
    let st=s:get_visual_selection()
    echo 'Finding "'.st.'"'
    exe "vert scs find f ".st
    botright copen
endfunc
vnoremap <leader>vf :call VCsfv()<cr>


"just split!!
func! Split()
    exe "sp"
endfunc
nmap <leader>ss :call Split()<cr>

"just split & open!!
func! SplitOpen()
    exe "sp ."
endfunc
nmap <leader>se :call SplitOpen()<cr>

"just split vertically!!
func! VSplit()
    exe "vs"
endfunc
nmap <leader>vv :call VSplit()<cr>

"just split & open vertically!!
func! VSplitOpen()
    exe "vs ."
endfunc
nmap <leader>ve :call VSplitOpen()<cr>

"toggle the AnsiEsc mode
func! Toggle_AnsiEsc()
    exe "AnsiEsc"
endfunc
nmap <leader>a :call Toggle_AnsiEsc()<cr>

" 1st fn key block
"map <F2> :ConqueGdb<CR>
"map <F2> v]}zf "folding from { till }
map <F2> :MRU<CR>
"nnoremap <silent> <F3> :tabn<CR>
"map <F3> @ "recording the action
map <F3> :tabnext<CR>
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
"let g:ConqueTerm_StartMessages=0
map <F12> :q!<CR>


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
"map <C-O>	:tabe ./<CR>
"map <C-N>	:tabnew<CR>

" ConqueGdb
let g:ConqueGdb_GdbExe = '/home/cy13shin/bin/abin/agdb'

" DirDiff
"let g:DirDiffExcludes = "CVS,*.class,*.o,*.cmd,*.swp,*.jar,vmlinux,*.dex,*.out,tags,cscope.files,.git,.a,.order,.tmp,.dtb"
let g:DirDiffExcludes = "CVS,*.class,*.o,*.cmd,*.swp,*.jar,vmlinux,*.dex,*.out,tags,cscope.files,.git,.a,.order,.tmp*,.dtb,.gdb*,Image,zImage,*.a,*.ko"

" diff colors
"highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
"highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
"highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
"highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta
highlight! link DiffText MatchParen

"listchars
"shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

nmap <C-H> :vertical res-1<CR>
nmap <C-J> :res-1<CR>
nmap <C-K> :res+1<CR>
nmap <C-L> :vertical res+1<CR>
nmap <C-=> <C-W>=<CR>

" mycomment
let g:userid="cysh@mc_wifi"
func! MyComment()
	let usercomment = printf(" // %s %s ", g:userid,strftime("%m%d%H%M"))
	exe "normal A ".usercomment	
endfunc
nmap <leader>kk :call MyComment()<cr>
"hi def mycomment_color ctermfg=green guifg=green ctermbg=white guibg=white
"syn match mycomment / cysh /
"highlight link mycommet mycomment_color

"let g:SuperTabDefaultCompletionType = "context"
"let g:snips_trigger_key='<c-space>'

" get the current position
let curpos = ""
func! GetCurPos()
	let g:curpos = printf(" %s:%d", expand('%@:p'), line("."))
	echo 'Got the Current Position : '.g:curpos
endfunc
nmap <leader>py :call GetCurPos()<cr>

" put the current position
func! PutCurPos()
	exe 'normal A '.g:curpos
endfunc
nmap <leader>pp :call PutCurPos()<cr>

" drlog function
func! LogPositioningFunction_1stFind()
	call Cstv()
	call GetCurPos()
endfunc
vnoremap <leader>pf :call LogPositioningFunction_1stFind()<cr>

func! LogPositioningFunction_2ndRecord()
	call MyComment()
	call PutCurPos()	
endfunc
nmap <leader>pr :call LogPositioningFunction_2ndRecord()<cr>

let g:netrw_localrmdir="rm -r"

let g:MARK_MARKS=1
set viminfo+=!

" Grep.vim need to check again. doesn't work well
"let Grep_Default_Filelist = '*.[chS] *.lds *.log *.logcat *.dmesg *.txt'
"let Grep_Default_Filelist = '*'
let Grep_Skip_Dirs='.git'
let Grep_Default_Options= '-rn'
"As for now, couldn't find a way to use grep.vim to find a visually selected
"sentence. Thus decided to use built-in vimgrep for a while
set wildignore+=*.class,*.o,*.cmd,*.swp,*.jar,vmlinux,*.dex,*.out,tags,cscope.files,.git,.a,.order,.tmp*,.dtb,.gdb*,Image,zImage,*.a,*.ko
func! Grep_It()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "vimgrep ".st." %"
    botright copen
endfunc
nmap <leader>gg :call Grep_It()<cr>

func! Grep_It_Recursively()
    let st=expand("<cword>")
    exe "Mark ".st
    exe "Rgrep ".st
    botright copen
endfunc
nmap <leader>gr :call Grep_It_Recursively()<cr>

" these 2 are replaced with unimpaired.vim
"nmap <leader>gn :cn<cr>
"nmap <leader>gp :cp<cr>

"tabbing
nmap <leader>td :tabe %<cr>
nmap <leader>te :tabe .<cr>
nmap <leader>tn :tabn<cr>
nmap <leader>tp :tabprev<cr>

"set it to the current directory
nnoremap <leader>dc :cd %:p:h<cr>

"VimCommander
nmap <leader>ee :call VimCommanderToggle()<cr>
"Midnight Commander
nmap <leader>mm :!mc<cr>

"Syntastic makes Vim so slower thus removed it
"let g:syntastic_check_on_open=1
let g:syntastic_enable_sign=1

"Airline
let g:airline#extension#tabline#enabled=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='powerlineish'
"let g:airline_theme='wombat'

"Tabline
hi TabLineSel term=bold cterm=bold ctermfg=22 ctermbg=148 gui=bold guifg=#005f00 guibg=#afd700
