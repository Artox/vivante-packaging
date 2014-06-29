#!/bin/bash -e

# pkg settings
pkg_name="gstreamer-plugins-imx"
pkg_name_suffix="1.0"
pkg_version="1"
pkg_arch="armv7hl"

# create packages
fpm -s empty -t rpm \
	--name $pkg_name-$pkg_name_suffix \
	--version $pkg_version \
	--architecture $pkg_arch \
        --depends $pkg_name-common-$pkg_name_suffix \
	--depends $pkg_name-v4l2src-$pkg_name_suffix \
        --depends $pkg_name-vpu-$pkg_name_suffix \
        --depends $pkg_name-ipu-$pkg_name_suffix

fpm -s dir -t rpm \
	--name $pkg_name-common-$pkg_name_suffix \
	--version $pkg_version \
	--architecture $pkg_arch \
        --depends libgstreamer-1.0.so.0 \
	--depends libgobject-2.0.so.0 \
	--depends libgmodule-2.0.so.0 \
	--depends libgthread-2.0.so.0 \
 	--depends libglib-2.0.so.0 \
	--depends libgstbase-1.0.so.0 \
	--depends libgstvideo-1.0.so.0 \
	--depends libpthread.so.0 \
	--depends libm.so.6 \
	--depends libc.so.6 \
	--provides libgstimxcommon.so.0 \
	-C dest \
	usr/lib/libgstimxcommon.so.0.9.1 \
	usr/lib/libgstimxcommon.so.0

fpm -s dir -t rpm \
        --name $pkg_name-v4l2src-$pkg_name_suffix \
        --version $pkg_version \
        --architecture $pkg_arch \
	--depends libgstimxcommon.so.0 \
        --depends libgstreamer-1.0.so.0 \
        --depends libgobject-2.0.so.0 \
        --depends libgmodule-2.0.so.0 \
        --depends libgthread-2.0.so.0 \
        --depends libglib-2.0.so.0 \
        --depends libgstbase-1.0.so.0 \
        --depends libgstvideo-1.0.so.0 \
        --depends libpthread.so.0 \
        --depends libm.so.6 \
        --depends libc.so.6 \
        -C dest \
        usr/lib/gstreamer-1.0/libgstimxv4l2src.so

fpm -s dir -t rpm \
	--name $pkg_name-vpu-$pkg_name_suffix \
	--version $pkg_version \
	--architecture $pkg_arch \
	--depends libgstimxcommon.so.0 \
	--depends libgstreamer-1.0.so.0 \
	--depends libgobject-2.0.so.0 \
	--depends libgmodule-2.0.so.0 \
	--depends libgthread-2.0.so.0 \
	--depends libglib-2.0.so.0 \
	--depends libgstbase-1.0.so.0 \
	--depends libgstvideo-1.0.so.0 \
	--depends libpthread.so.0 \
	--depends libm.so.6 \
	--depends libfslvpuwrap.so.3 \
	--depends libc.so.6 \
	-C dest \
	usr/lib/gstreamer-1.0/libgstimxvpu.so

fpm -s dir -t rpm \
        --name $pkg_name-ipu-$pkg_name_suffix \
        --version $pkg_version \
        --architecture $pkg_arch \
        --depends libgstimxcommon.so.0 \
        --depends libgstreamer-1.0.so.0 \
        --depends libgobject-2.0.so.0 \
        --depends libgmodule-2.0.so.0 \
        --depends libgthread-2.0.so.0 \
        --depends libglib-2.0.so.0 \
        --depends libgstbase-1.0.so.0 \
        --depends libgstvideo-1.0.so.0 \
        --depends libpthread.so.0 \
        --depends libm.so.6 \
        --depends libc.so.6 \
        -C dest \
        usr/lib/gstreamer-1.0/libgstimxipu.so
