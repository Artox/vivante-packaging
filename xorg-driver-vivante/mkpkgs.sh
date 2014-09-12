#!/bin/bash -e

# pkg infos
name=xf86-video-vivante-3.10.17
version=1.0.1
release=1
architecture=armv7hl

# first fetch source if necessary
../fetch.sh xserver-xorg-video-imx-viv-3.10.17-1.0.1.tar.gz 974f33945dc96e876907541906297798

# unpack source if necessary
srcdir=xserver-xorg-video-imx-viv-3.10.17-1.0.1
if [ ! -d "$srcdir" ]; then
	tar -xf xserver-xorg-video-imx-viv-3.10.17-1.0.1.tar.gz

        # apply patches
	patch -d $srcdir -p1 < Werror.patch
	patch -d $srcdir -p1 < libdrm.patch
#	patch -d $srcdir -p1 < xorg116.patch
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
	-n $name \
	-v $version \
	--iteration $release \
	-a $architecture \
	-d "libGAL.so" \
	-d "libGAL_x11" \
	-d "vivante_dri.so" \
	-d "X11_ABI_VIDEODRV = 14.1" \
	-C dest \
	usr

# delete buildroot
rm -Rf dest

# END
