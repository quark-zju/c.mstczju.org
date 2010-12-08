--[[------------------------------------------------------------------------------
-- Basic Compiling Policy
-- This file is pare of ZOJ 2.7
-- Copyright 2010-2011 WU Jun <quark@lihdd.net>
--]]------------------------------------------------------------------------------

limit = {
	time = TIME,
	data = MEMORY,
	memory = MEMORY,
	stack = 32,
	fileno = 64,
	wsize = 16,
	vmpeak = 1024,
	input = '/dev/null',
	output = OUTPUT,
	error = ERROR,
	uid = UID,
	gid = GID,
	chroot = CHROOT,
	chdir = CHDIR,
	env = '',
	deadline = DEADLINE,
	ban_write_open = false,
	ban_device = false,
	trace_syscall = false, -- Haskell seems need this
}

function set_program(path)
	return true
end

