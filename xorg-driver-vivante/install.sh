#!/bin/bash

# arguments accepted: sourcedir
usage() {
        echo "Usage: $0 <sourcedir> <destdir>"
}

# check arguments
if [ $# != 2 ]; then
        usage
        exit 1
fi

sourcedir="$1"
if [ ! -d "$sourcedir" ]; then
	echo sourcedir \"sourcedir\" does not exist!
	usage
	exit 1
fi

destdir="$2"
if [ ! -d "$destdir" ]; then
	echo destdir \"destdir\" does not exist!
	usage
	exit 1
fi

# relative to absolute paths
sourcedir=`readlink -f "$sourcedir"`
destdir=`readlink -f "$destdir"`

# BUILDING STARTS HERE
pushd "$sourcedir"

# build configuration
XSERVER_GREATER_THAN_13=1
BUILD_HARD_VFP=1

# build
./fastbuild.sh BUILD_HARD_VFP=1 XSERVER_GREATER_THAN_13=$XSERVER_GREATER_THAN_13

# install
install -v -m755 -D EXA/src/vivante_drv.so "${destdir}/usr/lib/xorg/modules/drivers/vivante_drv.so"
install -v -m755 -D FslExt/src/libfsl_x11_ext.so "${destdir}/usr/lib/xorg/modules/extensions/libfsl_x11_ext.so"
# TODO: autohdmi

popd
# END
