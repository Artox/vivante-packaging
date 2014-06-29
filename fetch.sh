#!/bin/bash

MIRRORS="http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/ http://download.ossystems.com.br/bsp/freescale/source/ http://downloads.yoctoproject.org/mirror/sources/"

fetch() {
	name=$1
	chksum=$2

	# check existing file
	chksum $name $chksum
	t=$?
	if [ "x$t" = "x0" ]; then
		echo "$name exists already and MD5 matches. Keeping the file."
		return 0
	else
		if [ "x$t" = "x2" ]; then
			echo "$name exists already but MD5 does not match. Deleting the file."
			rm -v $name
		fi
			# else t=1 >> file doesn't exist yet
	fi

	# try all mirrors
	for mirror in $MIRRORS; do

		# download
		wget $mirror/$name
		t=$?

		# handle wget return status
		if [ "x$t" = "x0" ]; then
			echo "$name downloaded."
			break
		else
			echo "Download of $name failed. Cleaning up."
			rm -fv $name
			continue
		fi

	done

	if  [ ! -f "$name" ]; then
		echo "Download of $name failed."
		return 1
	fi

	# check MD5 again
	chksum $name $chksum
	t=$?

	if [ "x$t" != "x0" ]; then
		echo "MD5 of downloaded file does not match! Keeping it anyway."
		return 1
	fi
}

chksum() {
	file=$1
	chksum=$2

	if [ ! -e "$file" ]; then
		return 1
	fi

	mysum=`md5sum $file | cut -d ' ' -f 1`
	if [ "$mysum" == "$chksum" ]; then
		return 0
	else
		return 2
	fi
}

usage() {
	echo "$0 <name> <md5sum>"
}

if [ $# -ne 2 ]; then
	usage
	exit 1
fi

fetch "$1" $2
