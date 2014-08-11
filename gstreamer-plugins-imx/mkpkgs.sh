#!/bin/bash -e

# pkg settings
pkg_name="gstreamer-plugins-1.0-imx"
pkg_version="0.9.7"
pkg_release="1"
pkg_arch="armv7hl"

# create packages
fpm -s empty -t rpm \
	--name $pkg_name \
	--version $pkg_version \
	--iteration ${pkg_release} \
	--architecture $pkg_arch \
        --depends $pkg_name-common \
	--depends $pkg_name-v4l2src \
        --depends $pkg_name-vpu \
        --depends $pkg_name-ipu \
	--depends $pkg_name-eglvivsink

fpm -s dir -t rpm \
	--name $pkg_name-common \
	--version $pkg_version \
	--iteration ${pkg_release} \
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
	usr/lib/libgstimxcommon.so.0.9.7 \
	usr/lib/libgstimxcommon.so.0

fpm -s dir -t rpm \
        --name $pkg_name-v4l2src \
        --version $pkg_version \
	--iteration ${pkg_release} \
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
	--name $pkg_name-vpu \
	--version $pkg_version \
	--iteration ${pkg_release} \
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
        --name $pkg_name-ipu \
        --version $pkg_version \
	--iteration ${pkg_release} \
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

fpm -s dir -t rpm \
	--name $pkg_name-eglvivsink \
	--version $pkg_version \
	--iteration ${pkg_release} \
	--architecture $pkg_arch \
	--depends libgstimxcommon.so.0 \
	--depends libEGL.so.1 \
	--depends libGLESv2.so.2 \
	--depends libX11.so.6 \
	--depends libgstvideo-1.0.so.0 \
	--depends libgstbase-1.0.so.0 \
	--depends libgstreamer-1.0.so.0 \
	--depends libgobject-2.0.so.0 \
	--depends libgmodule-2.0.so.0 \
	--depends libgthread-2.0.so.0 \
	--depends libglib-2.0.so.0 \
	--depends libpthread.so.0 \
	--depends libm.so.6 \
	--depends libc.so.6 \
	-C dest \
	usr/lib/gstreamer-1.0/libgstimxeglvivsink.so
