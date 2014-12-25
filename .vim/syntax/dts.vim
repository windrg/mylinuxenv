" Vim syntax file
" Language:Languagedts/dtsi (device tree files)
" Maintainer:MaintainerDaniel Mack <vim@zonque.org>
" Last Change:Change2013 Oct 20

if exists("b:current_syntax")
	finish
endif

"If it doesn't work on vim7.3, Ubuntu 12.04 or more older ones
"then move these 2 lines to .vimrc
au BufNewFile,BufRead *.dts setf dts
au BufNewFile,BufRead *.dtsi setf dts

syntax region dtsComment        start="/\*"  end="\*/"
syntax match  dtsReference      "&[[:alpha:][:digit:]_]\+"
syntax region dtsBinaryProperty start="\[" end="\]" 
syntax match  dtsStringProperty "\".*\""
syntax match  dtsKeyword        "/.\{-1,\}/"
syntax match  dtsLabel          "^[[:space:]]*[[:alpha:][:digit:]_]\+:"
syntax match  dtsNode           /[[:alpha:][:digit:]-_]\+\(@[0-9a-fA-F]\+\|\)[[:space:]]*{/he=e-1
syntax region dtsCellProperty   start="<" end=">" contains=dtsReference,dtsBinaryProperty,dtsStringProperty,dtsComment
syntax region dtsCommentInner   start="/\*"  end="\*/"
syntax match  dtsCommentLine    "//.*$"

hi def link dtsCellProperty     Number
hi def link dtsBinaryProperty   Number
hi def link dtsStringProperty   String
hi def link dtsKeyword          Include
hi def link dtsLabel            Label
hi def link dtsNode             Structure
hi def link dtsReference        Macro
hi def link dtsComment          Comment
hi def link dtsCommentInner     Comment 
hi def link dtsCommentLine      Comment
