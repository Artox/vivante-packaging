#!/bin/bash -e

# fetch source
../fetch.sh imx-vpu-3.10.17-1.0.0.bin 71ea1b803864101ebf88a1bab45514d2

# unpack source
if [ ! -d imx-vpu-3.10.17-1.0.0 ]; then
sh imx-vpu-3.10.17-1.0.0.bin --auto-accept --force
fi

basedir="$PWD"
sourcedir="imx-vpu-3.10.17-1.0.0"

# build source
pushd $sourcedir
make PLATFORM=IMX6Q
popd

# install binaries
pushd $sourcedir
make DEST_DIR="$basedir/dest" install
popd

# create packages

pkg_name="libvpu"
pkg_version="1"
pkg_arch=armv7hl

fpm -s dir -t rpm \
        --name $pkg_name \
        --version $pkg_version \
        --architecture $pkg_arch \
	--depends libpthread.so.0 \
        --depends libgcc_s.so.1 \
        --depends libc.so.6 \
        -C dest \
        usr/lib/libvpu.so.4

fpm -s dir -t rpm \
        --name $pkg_name-devel \
        --version $pkg_version \
        --architecture $pkg_arch \
        --depends $pkg_name \
        -C dest \
        usr/lib/libvpu.so \
	usr/lib/libvpu.a \
	usr/include/vpu_io.h \
	usr/include/vpu_lib.h

echo Done
