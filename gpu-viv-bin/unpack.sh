#!/bin/bash -e

# This is an unpack script for gpu-viv-bin package

# arguments accepted: package destdir
usage() {
	echo "Usage: $0 <package> <destdir>"
}

# check arguments
if [ $# != 2 ]; then
	usage
	exit 1
fi

package="$1"
destdir="$2"

pushd "$destdir"
unpackedname=`basename $package | sed -e "s;\.bin;;g"`
if [ ! -d "$unpackedname" ]; then
	sh "$package" --auto-accept --force
else
	exit 0
fi
popd

# apply patches
patch -d "$destdir/$unpackedname" -p1 < correct-linux.platform-macro.patch

# add additional files

# pkg-config
#cp -v egl.pc "$destdir/$unpackedname"/usr/lib/pkgconfig/
