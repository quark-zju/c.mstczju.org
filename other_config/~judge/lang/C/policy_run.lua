--[[------------------------------------------------------------------------------
-- Running Policy for Native Programs (C, C++, ghc, ...)
-- no exec, no readdir
-- This file is pare of ZOJ 2.7
-- Copyright 2010-2011 WU Jun <quark@lihdd.net>
--]]------------------------------------------------------------------------------

limit = {
	time = TIME,                     -- total running time limit, second
	data = MEMORY,                   -- data (data segment), MB (per process)
	memory = MEMORY,                 -- total memory limit, MB (total)
	stack = 16,                   -- stack, MB (per process)
	fileno = 64,                  -- max file count (per process)
	wsize = 16,                   -- output limit, MB
	vmpeak = 512,                 -- hard memory limit, MB (per process)
	-- if above settings are < 0, then not limited
	input = INPUT,
	                              -- input path to redirect (fs not sandboxed)
	output = OUTPUT, 
	                              -- output path to redirect (fs not sandboxed)
	error = ERROR, 
	-- if above settings are '', or not existed, then no redirect
	uid = UID,      -- uid
	gid = GID,                   -- gid
	-- if above settings are not present, current uid/gid (if not root),
	-- or (8161)/users will be used !
	chroot = CHROOT,      -- default: '/sandboxroot'
	chdir = CHDIR,  -- default: '/', note this path is in chrooted env
	-- Note that chrooted fs SHOULD be a SUBSET of real fs
	env = '',                     -- environment, e.g. 'LOG=1\nTHERE=2\n...', (always empty?)
	deadline = DEADLINE,               -- real time deadline for whole session, seconds
	-- it is in real time (not cpu time) and is not measured very accurately
	-- trace_syscall = true,      -- do not modify this unless you know what you are doing
}

syscall_mask = {
	[0] = false, -- restart
	[1] = true, -- exit
	[2] = 32, -- fork
	[3] = true, -- read
	[4] = true, -- write
	[5] = true, -- open
	[6] = true, -- close
	[7] = true, -- waitpid
	[8] = true, -- creat
	[9] = false, -- link (filter)
	[10] = false, -- unlink (filter)
	[11] = false, -- execve
	[12] = false, -- chdir
	[13] = true, -- time
	[14] = false, -- mknod
	[15] = false, -- chmod
	[16] = false, -- lchown
	[17] = false, -- break (unimp. syscall)
	[18] = true, -- oldstat
	[19] = true, -- lseek
	[20] = true, -- getpid
	[21] = false, -- mount
	[22] = false, -- umount
	[23] = false, -- setuid
	[24] = true, -- getuid
	[25] = true, -- stime
	[26] = false, -- ptrace
	[27] = true, -- alarm
	[28] = true, -- oldfstat
	[29] = true, -- pause
	[30] = true, -- utime
	[31] = false, -- stty (unimp. syscall)
	[32] = false, -- gtty
	[33] = true, -- access (check permission)
	[34] = false, -- nice
	[35] = false, -- ftime (unimp. syscall)
	[36] = true, -- sync
	[37] = true, -- kill
	[38] = false, -- rename
	[39] = false, -- mkdir
	[40] = false, -- rmdir
	[41] = true, -- dup
	[42] = true, -- pipe
	[43] = true, -- times
	[44] = false, -- prof (unimp.)
	[45] = true, -- brk
	[46] = false, -- setgid
	[47] = true, -- getgid
	[48] = true, -- signal
	[49] = true, -- geteuid
	[50] = true, -- getegid
	[51] = false, -- acct (process accounting, useful at tracer?)
	[52] = false, -- umount2
	[53] = false, -- lock (unimp. syscall)
	[54] = true, -- ioctl
	[55] = true, -- fcntl
	[56] = false, -- mpx (unimp. syscall)
	[57] = false, -- setpgid (dangerous (?))
	[58] = false, -- ulimit (unimp.)
	[59] = false, -- oldolduname
	[60] = false, -- umask
	[61] = false, -- chroot
	[62] = false, -- ustat
	[63] = true, -- dup2
	[64] = true, -- getppid
	[65] = true, -- getpgrp
	[66] = true, -- setsid
	[67] = true, -- sigaction
	[68] = true, -- sgetmask
	[69] = true, -- ssetmask
	[70] = true, -- setreuid
	[71] = true, -- setregid
	[72] = true, -- sigsuspend
	[73] = true, -- sigpending
	[74] = true, -- sethostname
	[75] = false, -- setrlimit
	[76] = true, -- getrlimit
	[77] = true, -- getrusage
	[78] = true, -- gettimeofday
	[79] = true, -- settimeofday
	[80] = true, -- getgroups
	[81] = true, -- setgroups
	[82] = true, -- select
	[83] = true, -- symlink
	[84] = true, -- oldlstat
	[85] = true, -- readlink
	[86] = true, -- uselib
	[87] = false, -- swapon
	[88] = false, -- reboot
	[89] = false, -- readdir
	[90] = true, -- mmap
	[91] = true, -- munmap
	[92] = true, -- truncate
	[93] = true, -- ftruncate
	[94] = false, -- fchmod
	[95] = false, -- fchown
	[96] = true, -- getpriority
	[97] = false, -- setpriority
	[98] = false, -- profil (unimp.)
	[99] = false, -- statfs
	[100] = false, -- fstatfs
	[101] = false, -- ioperm
	[102] = false, -- socketcall
	[103] = false, -- syslog
	[104] = true, -- setitimer
	[105] = true, -- getitimer
	[106] = true, -- stat
	[107] = true, -- lstat
	[108] = true, -- fstat
	[109] = true, -- olduname
	[110] = false, -- iopl
	[111] = false, -- vhangup
	[112] = true, -- idle
	[113] = false, -- vm86old
	[114] = true, -- wait4
	[115] = false, -- swapoff
	[116] = true, -- sysinfo
	[117] = false, -- ipc
	[118] = true, -- fsync
	[119] = true, -- sigreturn
	[120] = 32, -- clone
	[121] = true, -- setdomainname
	[122] = true, -- uname
	[123] = false, -- modify_ldt
	[124] = false, -- adjtimex
	[125] = true, -- mprotect
	[126] = true, -- sigprocmask
	[127] = false, -- create_module
	[128] = false, -- init_module
	[129] = false, -- delete_module
	[130] = false, -- get_kernel_syms
	[131] = false, -- quotactl
	[132] = true, -- getpgid
	[133] = false, -- fchdir
	[134] = false, -- bdflush
	[135] = true, -- sysfs
	[136] = true, -- personality
	[137] = false, -- afs_syscall (unimp.)
	[138] = false, -- setfsuid
	[139] = false, -- setfsgid
	[140] = true, -- _llseek
	[141] = true, -- getdents
	[142] = true, -- _newselect
	[143] = true, -- flock
	[144] = true, -- msync
	[145] = true, -- readv
	[146] = true, -- writev
	[147] = true, -- getsid
	[148] = true, -- fdatasync
	[149] = true, -- _sysctl
	[150] = true, -- mlock
	[151] = true, -- munlock
	[152] = true, -- mlockall
	[153] = true, -- munlockall
	[154] = true, -- sched_setparam
	[155] = true, -- sched_getparam
	[156] = true, -- sched_setscheduler
	[157] = true, -- sched_getscheduler
	[158] = true, -- sched_yield
	[159] = true, -- sched_get_priority_max
	[160] = true, -- sched_get_priority_min
	[161] = true, -- sched_rr_get_interval
	[162] = true, -- nanosleep
	[163] = true, -- mremap
	[164] = true, -- setresuid
	[165] = true, -- getresuid
	[166] = false, -- vm86
	[167] = false, -- query_module
	[168] = true, -- poll
	[169] = false, -- nfsservctl
	[170] = false, -- setresgid
	[171] = false, -- getresgid
	[172] = false, -- prctl (?)
	[173] = true, -- rt_sigreturn
	[174] = true, -- rt_sigaction
	[175] = true, -- rt_sigprocmask
	[176] = true, -- rt_sigpending
	[177] = true, -- rt_sigtimedwait
	[178] = true, -- rt_sigqueueinfo
	[179] = true, -- rt_sigsuspend
	[180] = true, -- pread64
	[181] = true, -- pwrite64
	[182] = false, -- chown
	[183] = true, -- getcwd
	[184] = true, -- capget
	[185] = true, -- capset
	[186] = true, -- sigaltstack
	[187] = true, -- sendfile
	[188] = true, -- getpmsg
	[189] = true, -- putpmsg
	[190] = 32, -- vfork
	[191] = true, -- ugetrlimit
	[192] = true, -- mmap2
	[193] = true, -- truncate64
	[194] = true, -- ftruncate64
	[195] = true, -- stat64
	[196] = true, -- lstat64
	[197] = true, -- fstat64
	[198] = false, -- lchown32
	[199] = true, -- getuid32
	[200] = true, -- getgid32
	[201] = true, -- geteuid32
	[202] = true, -- getegid32
	[203] = true, -- setreuid32
	[204] = true, -- setregid32
	[205] = true, -- getgroups32
	[206] = true, -- setgroups32
	[207] = false, -- fchown32
	[208] = true, -- setresuid32
	[209] = true, -- getresuid32
	[210] = true, -- setresgid32
	[211] = true, -- getresgid32
	[212] = false, -- chown32
	[213] = true, -- setuid32
	[214] = true, -- setgid32
	[215] = true, -- setfsuid32
	[216] = true, -- setfsgid32
	[217] = false, -- pivot_root
	[218] = true, -- mincore
	[219] = true, -- madvise
	[220] = true, -- madvise1
	[221] = true, -- getdents64
	[222] = true, -- fcntl64
	[223] = false, -- 223
	[224] = true, -- gettid
	[225] = true, -- readahead
	[226] = true, -- setxattr
	[227] = true, -- lsetxattr
	[228] = true, -- fsetxattr
	[229] = true, -- getxattr
	[230] = true, -- lgetxattr
	[231] = true, -- fgetxattr
	[232] = true, -- listxattr
	[233] = true, -- llistxattr
	[234] = true, -- flistxattr
	[235] = true, -- removexattr
	[236] = true, -- lremovexattr
	[237] = true, -- fremovexattr
	[238] = true, -- tkill
	[239] = true, -- sendfile64
	[240] = true, -- futex
	[241] = true, -- sched_setaffinity
	[242] = true, -- sched_getaffinity
	[243] = true, -- set_thread_area
	[244] = true, -- get_thread_area
	[245] = true, -- io_setup
	[246] = true, -- io_destroy
	[247] = true, -- io_getevents
	[248] = true, -- io_submit
	[249] = true, -- io_cancel
	[250] = true, -- fadvise64
	[251] = false, -- 251
	[252] = true, -- exit_group
	[253] = true, -- lookup_dcookie
	[254] = true, -- epoll_create
	[255] = true, -- epoll_ctl
	[256] = true, -- epoll_wait
	[257] = true, -- remap_file_pages
	[258] = true, -- set_tid_address
	[259] = true, -- timer_create
	[260] = true, -- timer_settime
	[261] = true, -- timer_gettime
	[262] = true, -- timer_getoverrun
	[263] = true, -- timer_delete
	[264] = true, -- clock_settime
	[265] = true, -- clock_gettime
	[266] = true, -- clock_getres
	[267] = true, -- clock_nanosleep
	[268] = true, -- statfs64
	[269] = true, -- fstatfs64
	[270] = true, -- tgkill
	[271] = true, -- utimes
	[272] = true, -- fadvise64_64
	[273] = false, -- vserver (unimp.)
	[274] = true, -- mbind
	[275] = true, -- get_mempolicy
	[276] = true, -- set_mempolicy
	[277] = false, -- mq_open 
	[278] = false, -- mq_unlink
	[279] = false, -- mq_timedsend
	[280] = false, -- mq_timedreceive
	[281] = false, -- mq_notify
	[282] = false, -- mq_getsetattr
	[283] = false, -- kexec_load
	[284] = true, -- waitid
	[285] = false, -- sys_setaltroot
	[286] = false, -- add_key
	[287] = false, -- request_key
	[288] = false, -- keyctl
	[289] = true, -- ioprio_set
	[290] = true, -- ioprio_get
	[291] = true, -- inotify_init
	[292] = true, -- inotify_add_watch
	[293] = true, -- inotify_rm_watch
	[294] = true, -- migrate_pages
	[295] = false, -- openat (dangerous -.-|)
	[296] = false, -- mkdirat
	[297] = false, -- mknodat
	[298] = false, -- fchownat
	[299] = false, -- futimesat
	[300] = true, -- fstatat64
	[301] = false, -- unlinkat
	[302] = false, -- renameat
	[303] = false, -- linkat
	[304] = false, -- symlinkat
	[305] = false, -- readlinkat
	[306] = false, -- fchmodat
	[307] = false, -- faccessat
	[308] = true, -- pselect6
	[309] = true, -- ppoll
	[310] = false, -- unshare
	[311] = true, -- set_robust_list
	[312] = true, -- get_robust_list
	[313] = true, -- splice
	[314] = true, -- sync_file_range
	[315] = true, -- tee
	[316] = true, -- vmsplice
	[317] = true, -- move_pages
	[318] = true, -- getcpu
	[319] = true, -- epoll_pwait
	[320] = true, -- utimensat
	[321] = true, -- signalfd
	[322] = true, -- timerfd_create
	[323] = true, -- eventfd
	[324] = true, -- fallocate
	[325] = true, -- timerfd_settime
	[326] = true, -- timerfd_gettime
	[327] = true, -- signalfd4
	[328] = true, -- eventfd2
	[329] = true, -- epoll_create1
	[330] = true, -- dup3
	[331] = true, -- pipe2
	[332] = true, -- inotify_init1
	[333] = true, -- preadv
	[334] = true, -- pwritev
	[335] = true, -- rt_tgsigqueueinfo
	[336] = true, -- perf_event_open
	[337] = true, -- recvmmsg
}

function open_filter(path, read, write, create)
	if write or create then return false end
	if path:match('^/proc/') then return false end
	if path:match('//') or path:match('%.%.') then return false end
	if path:match('^/tmp/') then return false end
	return true
end

known_exec_match = {
	'/tmp/run',
}

function exec_filter(path)
	for _, v in pairs(known_exec_match) do
		if path:match(v) then return true end
	end
	return false
end

function set_program(path)
	-- syscall_mask, exec_filter, open_filter can be set here to
	-- use different policies with different programs
	-- syscall_mask[11] = false -- disable exec now
	return exec_filter(path)
end

