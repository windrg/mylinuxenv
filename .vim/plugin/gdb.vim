" Vim plugin to show colorised gdb log properly
" Last Change:  2013 May 28th
" Maintainer:  WinDragon <windrg00@gmail.com> 
" License:      Distributed under the same terms as Vim itself.
"
" ..under..improvement...

if exists("g:loaded_gdbsty")
    finish
endif
let g:loaded_gdbsty = 1


augroup gdblogstyle 
    autocmd!

    autocmd FileType gdb call s:AnsiEsc#AnsiEsc()
augroup END

" vim: ts=4 et sw=4
