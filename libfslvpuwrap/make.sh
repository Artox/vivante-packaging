#!/bin/bash -e

# fetch source
../fetch.sh libfslvpuwrap-1.0.46.bin 1f50110cb6de8ebf767fb9c5f8baf20d

# unpack source
sourcedir=libfslvpuwrap-1.0.46
if [ ! -d "$sourcedir" ]; then
sh libfslvpuwrap-1.0.46.bin --auto-accept --force
fi

basedir="$PWD"

# build source
pushd $sourcedir
if [ ! -e autogen.done ]; then
NOCONFIGURE=1 ./autogen.sh
touch autogen.done
fi
./configure --prefix=/usr --docdir=/usr/share/doc/packages/libfslvpuwrap
make
popd

# install binaries
pushd $sourcedir
make DESTDIR="$basedir/dest" install
popd

# create packages

pkg_name="libfslvpuwrap"
pkg_version="1.0.46"
pkg_release="1" # increment with changes
pkg_arch=armv7hl

fpm -s dir -t rpm \
        --name $pkg_name \
        --version $pkg_version \
        --iteration ${pkg_release} \
        --architecture $pkg_arch \
        --depends libvpu.so.4 \
        --depends libc.so.6 \
	--provides libfslvpuwrap.so.3 \
        -C dest \
        usr/lib/libfslvpuwrap.so.3.0.0 \
	usr/lib/libfslvpuwrap.so.3 \
	usr/share/doc/packages/libfslvpuwrap

fpm -s dir -t rpm \
        --name $pkg_name-devel \
        --version $pkg_version \
        --architecture $pkg_arch \
        --depends $pkg_name \
        -C dest \
        usr/lib/libfslvpuwrap.so \
        usr/lib/libfslvpuwrap.a \
        usr/include/imx-mm/vpu \
        usr/lib/pkgconfig/libfslvpuwrap.pc \

fpm -s dir -t rpm \
        --name $pkg_name-examples \
        --version $pkg_version \
        --architecture $pkg_arch \
        -C dest \
        usr/share/imx-mm/video-codec

echo Done

