#!/bin/dash

if [ `whoami` != root ]; then
	echo 'Must be root'
	exit 1
fi

exec cgclear
