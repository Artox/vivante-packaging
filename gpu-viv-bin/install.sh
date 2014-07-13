#!/bin/bash -e

# This is an install script for vivante binaries
# it integrates them into the tree

# arguments accepted: sourcedir destdir backend
usage() {
	echo "Usage: $0 <sourcedir> <destdir> <backend>"
}

do_install() {
	SOURCEDIR="$1"
	DESTDIR="$2"
	BACKEND=$3

	pushd "$SOURCEDIR"

	# libGAL
if [ "x${BACKEND}" != "xnone" ]; then
	install -v -m755 -D usr/lib/libGAL-${BACKEND}.so "${DESTDIR}/usr/lib/libGAL.so"
	mkdir -p "${DESTDIR}/etc/udev/rules.d"
	touch "${DESTDIR}/etc/udev/rules.d/vivante.rules"
	echo 'KERNEL=="galcore", GROUP="video", MODE="660"' > "${DESTDIR}/etc/udev/rules.d/vivante.rules"
fi

	# libGAL-devel (HAL)
	install -v -m755 -d "${DESTDIR}/usr/include/HAL"
	install -v -m644 usr/include/HAL/* "${DESTDIR}/usr/include/HAL/"

	# OpenGL
	install -v -m755 -D usr/lib/libGL.so.1.2 "${DESTDIR}/usr/lib/libGL.so.1.2.0"
	ln -sv libGL.so.1.2.0 "${DESTDIR}/usr/lib/libGL.so.1.2"
	ln -sv libGL.so.1.2 "${DESTDIR}/usr/lib/libGL.so.1"
	ln -sv libGL.so.1 "${DESTDIR}/usr/lib/libGL.so"

	# EGL
if [ "x${BACKEND}" != "xnone" ]; then
	install -v -m755 -D usr/lib/libEGL-${BACKEND}.so "${DESTDIR}/usr/lib/libEGL.so.1.0.0"
	ln -sv libEGL.so.1.0.0 "${DESTDIR}/usr/lib/libEGL.so.1"
fi

	# EGL devel
	ln -sv libEGL.so.1 "${DESTDIR}/usr/lib/libEGL.so"
	install -v -m755 -d "${DESTDIR}/usr/include/EGL"
	install -v -m644 usr/include/EGL/* "${DESTDIR}/usr/include/EGL/"
	install -v -m644 -D usr/include/KHR/khrplatform.h "${DESTDIR}/usr/include/KHR/khrplatform.h"
	install -v -m644 -D usr/lib/pkgconfig/egl.pc "${DESTDIR}/usr/lib/pkgconfig/egl.pc"

	# OpenGLES
	install -v -m755 -D usr/lib/libGLES_CL.so "${DESTDIR}/usr/lib/libGLES_CL.so"
	install -v -m755 -D usr/lib/libGLES_CM.so "${DESTDIR}/usr/lib/libGLES_CM.so"

	# OpenGL-ES 1
	install -v -m755 -D usr/lib/libGLESv1_CL.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CL.so.1.1.0"
	ln -sv libGLESv1_CL.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CL.so.1"
	install -v -m755 -D usr/lib/libGLESv1_CM.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CM.so.1.1.0"
	ln -sv libGLESv1_CM.so.1.1.0 "${DESTDIR}/usr/lib/libGLESv1_CM.so.1"

	# OpenGL-ES 1 devel
	ln -sv libGLESv1_CM.so.1 "${DESTDIR}/usr/lib/libGLESv1_CM.so"
	ln -sv libGLESv1_CL.so.1 "${DESTDIR}/usr/lib/libGLESv1_CL.so"
	install -v -m755 -d "${DESTDIR}/usr/include/GLES"
	install -v -m644 usr/include/GLES/* "${DESTDIR}/usr/include/GLES/"
	install -v -m644 -D usr/lib/pkgconfig/glesv1_cm.pc "${DESTDIR}/usr/lib/pkgconfig/glesv1_cm.pc"

	# OpenGL-ES 2.0
if [ "x${BACKEND}" != "xnone" ]; then
	install -v -m755 -D usr/lib/libGLESv2-${BACKEND}.so "${DESTDIR}/usr/lib/libGLESv2.so.2.0.0"
	ln -sv libGLESv2.so.2.0.0 "${DESTDIR}/usr/lib/libGLESv2.so.2"
fi

	# OpenGL-ES 2.0 devel
	ln -sv libGLESv2.so.2 "${DESTDIR}/usr/lib/libGLESv2.so"
	install -v -m755 -d "${DESTDIR}/usr/include/GLES2"
	install -v -m644 usr/include/GLES2/* "${DESTDIR}/usr/include/GLES2/"
	install -v -m644 -D usr/lib/pkgconfig/glesv2.pc "${DESTDIR}/usr/lib/pkgconfig/glesv2.pc"

	# OpenVG
	install -v -m755 -D usr/lib/libOpenVG_3D.so "${DESTDIR}/usr/lib/libOpenVG_3D.so"
	install -v -m755 -D usr/lib/libOpenVG_355.so "${DESTDIR}/usr/lib/libOpenVG_355.so"
	ln -sv libOpenVG_3D.so "${DESTDIR}/usr/lib/libOpenVG.so"

	# OpenVG devel
	install -v -m755 -d "${DESTDIR}/usr/include/VG"
	install -v -m644 usr/include/VG/* "${DESTDIR}/usr/include/VG/"
	install -v -m644 -D usr/lib/pkgconfig/vg.pc "${DESTDIR}/usr/lib/pkgconfig/vg.pc"

	# OpenCL
	install -v -m755 -D usr/lib/libOpenCL.so "${DESTDIR}/usr/lib/libOpenCL.so"

	# OpenCL devel
	install -v -m755 -d "${DESTDIR}/usr/include/CL"
	install -v -m644 usr/include/CL/* "${DESTDIR}/usr/include/CL/"

	# VDK
	install -v -m755 -D usr/lib/libVDK.so "${DESTDIR}/usr/lib/libVDK.so"

	# VDK-devel
	install -v -m755 -d "${DESTDIR}/usr/include"
	install -v -m644 usr/include/*vdk*.h "${DESTDIR}/usr/include/"

	# VIVANTE
if [ "x${BACKEND}" != "xnone" ]; then
	install -v -m755 -D usr/lib/libVIVANTE-${BACKEND}.so "${DESTDIR}/usr/lib/libVIVANTE.so"
fi

	# GLSLC
	install -v -m755 -D usr/lib/libGLSLC.so "${DESTDIR}/usr/lib/libGLSLC.so"

	# CLC
	install -v -m755 -D usr/lib/libCLC.so "${DESTDIR}/usr/lib/libCLC.so"

	# demos are only for framebuffer
	if [ "x${BACKEND}" = "xfb" ]; then
		install -v -m755 -d "${DESTDIR}/opt/viv_samples"
		echo opt/viv_samples/\*
		cp -r opt/viv_samples/* "${DESTDIR}/opt/viv_samples/"
	fi

	# DRI, for X11
	if [ "x${BACKEND}" = "xx11" ]; then
		install -v -m755 -D usr/lib/dri/vivante_dri.so "${DESTDIR}/usr/lib/dri/vivante_dri.so"

		# the x11 driver is xserver-xorg-video-imx-viv and opensource
	fi

	# TODO: DFB, WL, PKG-CONFIG

	popd
}

# check arguments
if [ $# != 3 ]; then
	usage
	exit 1
fi

sourcedir=$1
if [ ! -d "$sourcedir" ]; then
	echo sourcedir \"sourcedir\" does not exist!
	usage
	exit 1
fi

destdir=$2
if [ ! -d "$destdir" ]; then
	echo destdir \"$destdir\" does not exist!
	usage
	exit 1
fi

# if paths are relative, make them absolute
sourcedir=`readlink -f "$sourcedir"`
destdir=`readlink -f "$destdir"`

backend=$3
if [ "x$backend" != "xfb" ]; then
	if [ "x$backend" != "xdfb" ]; then
		if [ "x$backend" != "xx11" ]; then
			if [ "x$backend" != "xwl" ]; then
				if [ "x$backend" != "xnone" ]; then
					echo Invalid backend \"$backend\"!
					usage
					exit 1
				fi
			fi
		fi
	fi
fi

do_install "$sourcedir" "$destdir" $backend
exit $?

echo unexpected end of script!
exit 1
