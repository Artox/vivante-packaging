#!/bin/bash

# pkg infos
name=xf86-video-vivante-3.10.17
version=1.0.0
release=0
architecture=armv7hl

# first fetch source if necessary
../fetch.sh xserver-xorg-video-imx-viv-3.10.17-1.0.0.tar.gz 697d9a3fb244eb95eae4207bf2d9c321

# unpack source if necessary
srcdir=xserver-xorg-video-imx-viv-3.10.17-1.0.0
if [ ! -d "$srcdir" ]; then
	tar -xf xserver-xorg-video-imx-viv-3.10.17-1.0.0.tar.gz

        # apply patches
	patch -d $srcdir -p1 < Werror.patch
	patch -d $srcdir -p1 < libdrm.patch
	patch -d $srcdir -p1 < xorg116.patch
fi

# BUILDING STARTS HERE

# delte buildroot if any
if [ -d dest ]; then
	rm -Rf dest
fi

# compile and install it
mkdir dest
./install.sh $srcdir dest

# pack it
fpm -s dir -t rpm \
	-n $name-fb \
	-v $version \
	--iteration $release \
	-a $architecture \
	-d "gpu-viv-bin-mx6q-3.10.17-x11 = 1.0.0" \
	-C dest \
	usr

# delete buildroot
rm -Rf dest

# END
