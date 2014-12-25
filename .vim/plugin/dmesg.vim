" Vim syntax file
" Language:         log, dmesg , kernel message
" Maintainer:       WinDragon <windrg00@gmail.com>
" Latest Revision:  2014-06-02

if exists("g:/loaded_dmesgish")
    finish
endif
let g:loaded_dmesgish = 1

augroup dmesgish
	au BufRead,BufNewfile *.dmesg setfiletype dmesg

	autocmd FileType dmesg call s:DmesgHighlighting()
augroup END


function s:DmesgHighlighting()
	hi def EMERG_color cterm=bold ctermfg=red ctermbg=white gui=bold guifg=red guibg=white
	syn match EMERG '^<0>.*'
	hi def link EMERG EMERG_color

	hi def ALERT_color cterm=bold ctermfg=black ctermbg=yellow gui=bold guifg=black guibg=yellow
	syn match ALERT '^<1>.*'
	hi def link ALERT ALERT_color

	hi def CRIT_color cterm=bold ctermfg=blue ctermbg=yellow gui=bold guifg=blue guibg=yellow
	syn match CRIT '^<2>.*'
	hi def link CRIT CRIT_color

	"hi def ERR_color cterm=bold ctermfg=white ctermbg=red gui=bold guifg=white guibg=red  // cysh@mc_wifi 10151435 it was too exotic
	hi def ERR_color cterm=bold ctermfg=208 gui=bold guifg=white guibg=red
	syn match ERR '^<3>.*'
	hi def link ERR ERR_color 

	hi def WARNING_color ctermfg=166 guifg=#df5f00
	syn match WARNING '^<4>.*'
	hi def link WARNING WARNING_color

	hi def NOTICE_color ctermfg=darkblue guifg=darkblue
	syn match NOTICE '^<5>.*'
	hi def link NOTICE NOTICE_color

	hi def INFO_color ctermfg=green guifg=green
	syn match INFO '^<6>.*'
	hi def link INFO INFO_color

	hi def DEBUG_color cterm=bold ctermfg=white gui=bold guifg=white
	syn match DEBUG '^<7>.*'
	hi def link DEBUG DEBUG_color 
endfunction
