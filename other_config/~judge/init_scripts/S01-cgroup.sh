#!/bin/bash

if [ `whoami` != root ]; then
	echo 'Must be root'
	exit 1
fi

CGDIR=/dev/cgroup
CGNAME=cgroup_zandbox

grep -q '^'$CGNAME /etc/mtab && exit

mkdir -p $CGDIR

# mount cgroup
mount -t cgroup -o cpuacct,memory,devices,freezer $CGNAME $CGDIR && echo 'cgroup mounted'
