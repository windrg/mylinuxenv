" Vim plugin to show colorised gdb log properly
" Last Change:  2013 May 28th
" Maintainer:  WinDragon <windrg00@gmail.com> 
" License:      Distributed under the same terms as Vim itself.
"
" ..under..improvement...

if exists("g:loaded_gdbsty")
    finish
endif
if !has('python')
	echo "Error: Required vim compiled with +python"
	finish
endif
let g:loaded_gdbsty = 1

augroup gdblogstyle 
	au BufRead,BufNewfile *.gdb setfiletype gdb

    autocmd FileType gdb exe "AnsiEsc"
augroup END

function! Align_var()
python << EOF
#print "Hello!!"
import vim

current_line = vim.current.line
lineno, col = vim.current.window.cursor
print "Aligning Line %d ..." % lineno
#vim.command(str(Command))
aligned_line = []
new_char = None
tab_depth = 0
was_equal = False

for i in range(0, len(current_line)):
    ch = current_line[i]
    if ch is '{':
	    if was_equal is True:
		    tab_depth += 1
	    new_char = '\n' + '\t' * tab_depth + '{\n'
	    tab_depth += 1
	    new_char += '\t' * tab_depth
    elif ch is '}':
	    tab_depth -= 1
	    new_char = '\n' + '\t' * tab_depth + '}\n'
	    if was_equal is True:
		    tab_depth -= 1
		    was_equal = False
	    new_char += '\t' * tab_depth
    elif ch is ',':
	    new_char = ',\n'
	    new_char += '\t' * tab_depth
    else:
	    new_char = ch

    aligned_line += new_char
    continue

    #vim.command("norm dd")
cmd = "norm o" + ''.join(aligned_line)
vim.command(cmd)

EOF
endfunction

"command! -nargs=0 Align call Align_var()
"nmap <leader>ga :call Align_var()<cr>
