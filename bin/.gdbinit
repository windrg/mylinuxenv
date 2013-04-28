set history save on
set history filename ~/.gdb_history
set output-radix 16

define connect
	#set remotebaud 115200 
	target remote /dev/ttyUSB0
	# if CONFIG_DEBUG_RODATA is set, you should use HW breakpoints
	#hbreak panic
	#hbreak sys_sync
	# else, you can use just SW breakpoints
	b panic
	b sys_sync
end

define snoopdbg
	set debug remote 1
end

define nosnoopdbg
	set debug remote 0
end

# android debug
define set_path
set solib-absolute-prefix ./out/target/product/universal_ss222ap/symbols/system
set solib-search-path ./out/target/product/universal_ss222ap/symbols/system/lib
end

# Helper function to find a task given a PID or the address of a task_struct.
# The resultis set into $t
define find_task
	# Addresses greater than _end: kernel data...
	# ...user passed in an address
	#if ((unsigned)$arg0 > (unsigned)&_end)
	# cysh now there is no symbol like '_end'
	if ((unsigned)$arg0 > (unsigned)0xc000000)
		set $t=(struct task_struct *)$arg0
	else
		# User entered a numeric PID
		# Walk the task list to find it
		set $t=&init_task	
		if (init_task.pid != (unsigned)$arg0)
			find_next_task $t
			while (&init_task!=$t && $t->pid != (unsigned)$arg0)
				find_next_task $t
			end
			if ($t == &init_task)
				printf "Couldn't find task; using init_task\n"
			end
		end
	end
	printf "Task \"%s\":\n", $t->comm
end

# Display process information
define ps
	# Print column headers
	task_struct_header
	set $t=&init_task
	task_struct_show $t
	find_next_task $t
	# Walk the list
	while &init_task!=$t
		# Display useful info about each task
		task_struct_show $t
		find_next_task $t
	end
end

document ps
Print points of interest for all tasks
end

define task_struct_show
	# task_struct addr and PID
	printf "0x%08x %5d", $arg0, $arg0->pid
	
	# Place a '<' marker on the current task	
	# if ( $arg0 == current )

	# For PowerPC, register r2 points to the "current" task 
#	if ( $arg0 == $r2 )
#		printf "<"
#	else
#		printf " "
#	end
	# windrg here should be replaced with the platform's. Now don't know what is for x86.
	printf " "

	# State
	if ($arg0->state == 0 )
		printf "Running  "
	else
		if ($arg0->state == 1)
			printf "Sleeping  "
		else
			if ($arg0->state == 2)
				printf "Disksleep  "
			else
				if ($arg0->state == 4)
					printf "Zombie  "
				else
					if ($arg0->state == 8)
						printf "sTopped  "
					else
						if ($arg0->state == 16)
							printf "wpaging  "
						else
							printf "%2d      ", $arg0->state
						end
					end
				end
			end
		end
	end
			
	# User NIP	
	#if ($arg0->thread.regs)
	#	printf "0x%08x ", $arg0->thread.regs->nip // for PowerPC
	#else
	#	printf "          "
	#end
	# for x86, not sure whether this is correct or not.
	printf "0x%08x ", $arg0->thread.ip

	# Display the kernel stack pointer
 	# windrg here should be replaced with the platform's 
	# printf "0x%08x ", $arg0->thread.ksp  // for PowerPC
	# for x86, not sure whether it is sp or sp0
	printf "0x%08x ", $arg0->thread.sp  

	# device
	if ($arg0->signal->tty)
		printf "%s   ", $arg0->signal->tty->name
	else
		printf "(none) "
	end

	# comm
	printf "%s\n", $arg0->comm
end

define find_next_task
	# Given a task address, find the next task in the linked list
	set $t = (struct task_struct *) $arg0
	set $offset=( (char *)&$t->tasks - (char *)$t)
	set $t=(struct task_struct *)( (char *)$t->tasks.next- (char *)$offset)
end

define task_struct_header
	printf "Address\tPID\tState\tUser_NIP\tKernel-SP\tdevice\tcomm\n"
end

define lsmod
	printf "Address\t\tModule\n"
	set $m=(struct list_head *)&modules
	set $done=0
	while( !$done )
		# list_head is 4-bytes into struct module
		set $mp=(struct module *)((char *)$m->next - (char *)4)
		printf "0x%08x\t%s\n", $mp, $mp->name
		if ( $mp->list->next == &modules )
			set $done=1
		end
		set $m=$m->next
	end
end

document lsmod
List the loaded kernel modules and their start addresses
end

#
# This file contains a few gdb macros (user defined commands) to extract
# useful information from kernel crashdump (kdump) like stack traces of
# all the processes or a particular process and trapinfo.
#
# These macros can be used by copying this file in .gdbinit (put in home
# directory or current directory) or by invoking gdb command with
# --command=<command-file-name> option
#
# Credits:
# Alexander Nyberg <alexn@telia.com>
# V Srivatsa <vatsa@in.ibm.com>
# Maneesh Soni <maneesh@in.ibm.com>
#

define bttnobp
	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
	set $init_t=&init_task
	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
	while ($next_t != $init_t)
		set $next_t=(struct task_struct *)$next_t
		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
		printf "===================\n"
		set var $stackp = $next_t.thread.esp
		set var $stack_top = ($stackp & ~4095) + 4096

		while ($stackp < $stack_top)
			if (*($stackp) > _stext && *($stackp) < _sinittext)
				info symbol *($stackp)
			end
			set $stackp += 4
		end
		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
		while ($next_th != $next_t)
			set $next_th=(struct task_struct *)$next_th
			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
			printf "===================\n"
			set var $stackp = $next_t.thread.esp
			set var $stack_top = ($stackp & ~4095) + 4096

			while ($stackp < $stack_top)
				if (*($stackp) > _stext && *($stackp) < _sinittext)
					info symbol *($stackp)
				end
				set $stackp += 4
			end
			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
		end
		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
	end
end
document bttnobp
	dump all thread stack traces on a kernel compiled with !CONFIG_FRAME_POINTER
end

define btt
	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
	set $init_t=&init_task
	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
	while ($next_t != $init_t)
		set $next_t=(struct task_struct *)$next_t
		printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
		printf "===================\n"
		set var $stackp = $next_t.thread.esp
		set var $stack_top = ($stackp & ~4095) + 4096
		set var $stack_bot = ($stackp & ~4095)

		set $stackp = *($stackp)
		while (($stackp < $stack_top) && ($stackp > $stack_bot))
			set var $addr = *($stackp + 4)
			info symbol $addr
			set $stackp = *($stackp)
		end

		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
		while ($next_th != $next_t)
			set $next_th=(struct task_struct *)$next_th
			printf "\npid %d; comm %s:\n", $next_t.pid, $next_t.comm
			printf "===================\n"
			set var $stackp = $next_t.thread.esp
			set var $stack_top = ($stackp & ~4095) + 4096
			set var $stack_bot = ($stackp & ~4095)

			set $stackp = *($stackp)
			while (($stackp < $stack_top) && ($stackp > $stack_bot))
				set var $addr = *($stackp + 4)
				info symbol $addr
				set $stackp = *($stackp)
			end
			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
		end
		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
	end
end
document btt
	dump all thread stack traces on a kernel compiled with CONFIG_FRAME_POINTER
end

define btpid
	set var $pid = $arg0
	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
	set $init_t=&init_task
	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
	set var $pid_task = 0

	while ($next_t != $init_t)
		set $next_t=(struct task_struct *)$next_t

		if ($next_t.pid == $pid)
			set $pid_task = $next_t
		end

		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
		while ($next_th != $next_t)
			set $next_th=(struct task_struct *)$next_th
			if ($next_th.pid == $pid)
				set $pid_task = $next_th
			end
			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
		end
		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
	end

	printf "\npid %d; comm %s:\n", $pid_task.pid, $pid_task.comm
	printf "===================\n"
	set var $stackp = $pid_task.thread.esp
	set var $stack_top = ($stackp & ~4095) + 4096
	set var $stack_bot = ($stackp & ~4095)

	set $stackp = *($stackp)
	while (($stackp < $stack_top) && ($stackp > $stack_bot))
		set var $addr = *($stackp + 4)
		info symbol $addr
		set $stackp = *($stackp)
	end
end
document btpid
	backtrace of pid
end


define trapinfo
	set var $pid = $arg0
	set $tasks_off=((size_t)&((struct task_struct *)0)->tasks)
	set $pid_off=((size_t)&((struct task_struct *)0)->pids[1].pid_list.next)
	set $init_t=&init_task
	set $next_t=(((char *)($init_t->tasks).next) - $tasks_off)
	set var $pid_task = 0

	while ($next_t != $init_t)
		set $next_t=(struct task_struct *)$next_t

		if ($next_t.pid == $pid)
			set $pid_task = $next_t
		end

		set $next_th=(((char *)$next_t->pids[1].pid_list.next) - $pid_off)
		while ($next_th != $next_t)
			set $next_th=(struct task_struct *)$next_th
			if ($next_th.pid == $pid)
				set $pid_task = $next_th
			end
			set $next_th=(((char *)$next_th->pids[1].pid_list.next) - $pid_off)
		end
		set $next_t=(char *)($next_t->tasks.next) - $tasks_off
	end

	printf "Trapno %ld, cr2 0x%lx, error_code %ld\n", $pid_task.thread.trap_no, \
				$pid_task.thread.cr2, $pid_task.thread.error_code

end
document trapinfo
	Run info threads and lookup pid of thread #1
	'trapinfo <pid>' will tell you by which trap & possibly
	address the kernel panicked.
end

#cysh doesn't work well
define dmesg2
	set $i = 0
	set $end_idx = (log_end - 1) & (log_buf_len - 1)

	while ($i < logged_chars)
		set $idx = (log_end - 1 - logged_chars + $i) & (log_buf_len - 1)

		#if ($idx + 100 <= $end_idx) || \
		#   ($end_idx <= $idx && $idx + 100 < log_buf_len)
		#	printf "%.100s", &log_buf[$idx]
		#	set $i = $i + 100
		#else
			printf "%c", log_buf[$idx]
			set $i = $i + 1
		#end
	end
end
document dmesg2
	print the kernel ring buffer
end

define pldmod 
	set $m = (struct module *) $arg0
	set $m_name = (char *) $m.name
	set $text = $m->module_core
	set $init_text = $m->module_init
	printf "add-symbol-file <path to %s> 0x%08x -s .init.text 0x%08x\n", $m_name, $text, $init_text
end
document pldmod
	print a command line to load a module symbols
end

#cysh doesn't work well
define dmesg4
	set $__log_buf= (char *)__log_buf
	set $log_start=	0
	set $log_end= log_buf_len 
	set $x=$log_start
	while($x < $log_end)
		set $c = (char)(($__log_buf)[$x++])
		printf "%c", $c
	end
end
document dmesg4
dmesg 
Print the content of the kernel message buffer
end


#cysh doesn't work well
define logs
	printf "\n__log_buf 	: %08x\n", __log_buf
	printf "log_start 	: %d\n", log_start
	printf "log_end   	: %d\n", log_end
	printf "log_buf_len  	: %d\n\n", log_buf_len
end
document logs
Print the status of logs
end

define dmesg
	set $__log_buf= (char *)__log_buf
	set $log_start=	$arg0
	set $log_end= $arg1 
	set $x=$log_start
	echo "
	while($x < $log_end)
		set $c = (char)(($__log_buf)[$x++])
		printf "%c", $c
	end
	echo "\n
end
document dmesg
dmesg 
Print the content of the kernel message buffer
end

define modinfo 
	set $mp=(struct module *)$arg0
	printf "\nName : %s \n", $mp->name
	printf ".text : 0x%08x \n", $mp->module_core 
	printf ".init.text : 0x%08x \n\n", $mp->module_init
	printf " =>> add-symbol-file <path-to-file> 0x%08x -s .init.text 0x%08x \n\n", $mp->module_core, $mp->module_init
end
document modinfo 
Print the information of the given module address
end

