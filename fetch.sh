#!/bin/sh

MIRROR=http://download.ossystems.com.br/bsp/freescale/source/

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

	# download
	wget $MIRROR/$name
	t=$?

	# handle wget errors
	if [ "x$t" != "x0" ]; then
		echo "Download of $name failed. Cleaning up."
		rm -fv $name
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

# 3.0.35 softfloat
fetch gpu-viv-bin-mx6q-3.0.35-4.0.0.bin 2bb7d2f4bdff79ae99ce0c9fc2540701

# 3.5.7 softfloat
fetch gpu-viv-bin-mx6q-3.5.7-1.0.0-sfp.bin ccd12ee3aa6eaeb16e1073ed592b528a

# 3.5.7 hardfloat
fetch gpu-viv-bin-mx6q-3.5.7-1.0.0-hfp.bin 080225adc7aa61af7bfdab17527e62e3

chmod +x *.bin
