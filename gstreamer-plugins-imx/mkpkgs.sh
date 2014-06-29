#!/bin/bash -x

# pkg settings
pkg_name="gstreamer-plugins-imx-1.0"
pkg_version="1"
pkg_arch="armv7hl"

# create package
fpm -s dir -t rpm \
	--name $pkg_name \
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
	--depends libm.so.0 \
	--depends libc.so.6 \
	-C dest \
	usr/lib/libgstimxcommon.so.0.9.1 \
	usr/lib/gstreamer-1.0/libgstimxv4l2src.so \
	usr/lib/gstreamer-1.0/libgstimxvpu.so \
	usr/lib/gstreamer-1.0/libgstimxipu.so


# file list
## libgstimxcommon	
#dest/usr/lib/libgstimxcommon.so
#dest/usr/lib/libgstimxcommon.so.0
#dest/usr/lib/libgstimxcommon.so.0.9.1

## libgstimxv4l2src
#dest/usr/lib/gstreamer-1.0/libgstimxv4l2src.so

## libgstimxvpu
#dest/usr/lib/gstreamer-1.0/libgstimxvpu.so

## libgstimxipu
#dest/usr/lib/gstreamer-1.0/libgstimxipu.so
