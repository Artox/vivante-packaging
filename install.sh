#!/bin/sh

# This is an install script for vivante binaries
# it integrates them into the tree

# arguments accepted: basedir backend
usage() {
	echo "Usage: $0 <basedir> <backend>"
}

do_install() {
	DESTDIR="$1"
	BACKEND=$2

	# libGAL
	install -v -m755 -D usr/lib/libGAL-${BACKEND}.so "${DESTDIR}/usr/lib/libGAL.so"

	# OpenGL
	install -v -m755 -D usr/lib/libGL.so.1.2 "${DESTDIR}/usr/lib/libGL.so.1.2"
	ln -sv libGL.so.1.2 "${DESTDIR}/usr/lib/libGL.so.1"
	ln -sv libGL.so.1 "${DESTDIR}/usr/lib/libGL.so"

	# EGL
	install -v -m755 -D usr/lib/libEGL-${BACKEND}.so "${DESTDIR}/usr/lib/libEGL.so.1"

	# EGL devel
	ln -sv libEGL.so.1 "${DESTDIR}/usr/lib/libEGL.so"
	install -v -m755 -d "${DESTDIR}/usr/include/EGL"
	install -v -m644 usr/include/EGL/* "${DESTDIR}/usr/include/EGL/"
	install -v -m644 -D usr/include/KHR/khrplatform.h "${DESTDIR}/usr/include/KHR/khrplatform.h"

	# OpenGL-ES 1
	install -v -m755 -D usr/lib/libGLESv1_CM.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CM.so.1.1.0"
	ln -sv libGLESv1_CM.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CM.so.1"

	# OpenGL-ES 1 devel
	ln -sv libGLESv1_CM.so.1 "${DESTDIR}/usr/lib/libGLESv1_CM.so"
	install -v -m755 -d "${DESTDIR}/usr/include/GLES"
	install -v -m644 usr/include/GLES/* "${DESTDIR}/usr/include/GLES/"

	# OpenGL-ES 2.0
	install -v -m755 -D usr/lib/libGLESv2-${BACKEND}.so "${DESTDIR}/usr/lib/libGLESv2.so.2.0.0"
	ln -sv libGLESv2.so.2.0.0 "${DESTDIR}/usr/lib/libGLESv2.so.2"

	# OpenGL-ES 2.0 devel
	ln -sv libGLESv2.so.2 "${DESTDIR}/usr/lib/libGLESv2.so"
	install -v -m755 -d "${DESTDIR}/usr/include/GLES2"
	install -v -m644 usr/include/GLES2/* "${DESTDIR}/usr/include/GLES2/"

	# OpenVG
	install -v -m755 -D usr/lib/libOpenVG_3D.so "${DESTDIR}/usr/lib/libOpenVG_3D.so"
	install -v -m755 -D usr/lib/libOpenVG_355.so "${DESTDIR}/usr/lib/libOpenVG_355.so"
	ln -sv libOpenVG_3D.so "${DESTDIR}/usr/lib/libOpenVG.so"

	# OpenVG devel
	install -v -m755 -d "${DESTDIR}/usr/include/VG"
	install -v -m644 usr/include/VG/* "${DESTDIR}/usr/include/VG/"

	# OpenCL
	install -v -m755 -D usr/lib/libOpenCL.so "${DESTDIR}/usr/lib/libOpenCL.so"

	# OpenCL devel
	install -v -m755 -d "${DESTDIR}/usr/include/CL"
	install -v -m644 usr/include/CL/* "${DESTDIR}/usr/include/CL/"

	# VDK
	install -v -m755 -D usr/lib/libVDK.so "${DESTDIR}/usr/lib/libVDK.so"

	# VIVANTE
	install -v -m755 -D usr/lib/libVIVANTE-${BACKEND}.so "${DESTDIR}/usr/lib/libVIVANTE.so"

	# GLSLC
	install -v -m755 -D usr/lib/libGLSLC.so "${DESTDIR}/usr/lib/libGLSLC.so"

	# CLC
	install -v -m755 -D usr/lib/libCLC.so "${DESTDIR}/usr/lib/libCLC.so"

	# demos
	install -v -m755 -d "${DESTDIR}/opt/viv_samples"
	cp -rv opt/viv_samples/* "${DESTDIR}/opt/viv_samples/"

	# TODO: DRI, DFB, WL, PKG-CONFIG
}

# check arguments
if [ $# != 2 ]; then
	usage
	exit 1
fi

basedir=$1
if [ ! -d "$basedir" ]; then
	echo basedir \"$basedir\" does not exist!
	usage
	exit 1
fi

backend=$2
if [ "x$backend" = "xfb" ]; then
	do_install "$basedir" $backend
	exit $?
else
	if [ "x$backend" = "xdfb" ]; then
		do_install "$basedir" $backend
		exit $?
	else
		if [ "x$backend" = "xx11" ]; then
			do_install "$basedir" $backend
			exit $?
		else
			if [ "x$backend" = "xwl" ]; then
				do_install "$basedir" $backend
				exit $?
			else
				echo Invalid backend \"$backend\"!
				usage
				exit 1
			fi
		fi
	fi
fi

echo unexpected end of script!
exit 1
