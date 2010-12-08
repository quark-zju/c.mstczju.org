#!/bin/bash

if [ `whoami` != root ]; then
	echo 'Must be root'
	exit 1
fi

OLDPWD="$PWD"
cd $(dirname `readlink -f "$0"`)

SANDBOXROOT=/sandboxroot
RAMDIR=/tmp/ram

# === ONE RAMDISK =============================================
mkdir -p "${RAMDIR}" &> /dev/null
if ! mount | fgrep "${RAMDIR}" &>/dev/null; then
	echo "Setting ${RAMDIR}"
	mount -t tmpfs -o size=30%,mode=777 none "$RAMDIR"
fi
chmod a+rwX "$RAMDIR"

# === FS MIRROR SHELL FUNCTION =================================
mount_mirror() {
	mkdir -p "$1" &> /dev/null
	mkdir -p "$2" &> /dev/null
	echo "Mirroring '$1' => '$2'"
	if ! mount | fgrep "$2" &> /dev/null; then
		mount --rbind "$1" "$2"
	fi
}

mount_mirror_readonly() {
	mount_mirror "$1" "$2"
	echo "  Setting '$2' to read-only"
	mount -o remount,ro "$2"
}

# === SANDBOXFS FOR EACH USER BELONGING TO 'JUDGE' GROUP =======
groupmems -g judge -l | grep -o '[^ ]*' | while read user; do
	USROOT=${SANDBOXROOT}/${user}

	# /tmp/ram/_user => /sandboxroot/_user/tmp, rw
	mount_mirror "${RAMDIR}/${user}" "${USROOT}/tmp" 

	# daily fs part
	# Java (gcj) needs /proc ...
	# perl lib needs /usr/share/...
	# mono C# is evil, needs /proc and writable /tmp, banned!
	for i in '/bin' '/usr/include' '/lib' '/usr/lib' '/usr/bin' '/proc' '/usr/share'; do
		mount_mirror_readonly "${i}" "${USROOT}$i"
	done

	# chmod/own at last
	chmod a-w,a+rX "$USROOT"
	chown root:root "$USROOT"
	chmod a+rwX "${USROOT}/tmp"
done

chmod a-w,a+rX "$SANDBOXROOT"
chown root:root "$SANDBOXROOT"

# bind essential directories, make them read-only


cd "$OLDPWD"
echo "Sandbox filesystem setted up."
