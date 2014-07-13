#!/bin/bash -e

# This script packs vivante bianries into RPMs

# arguments accepted: sourcedir backend
usage() {
	echo "Usage: $0 <sourcedir> <backend>"
}

# check arguments
if [ $# != 2 ]; then
	usage
	exit 1
fi

sourcedir="$1"
if [ ! -d "$sourcedir" ]; then
	echo "sourcedir does not exist!"
	usage
	exit 1
fi

viv_backend=$2
if [ "x$viv_backend" != "xfb" ]; then
	if [ "x$viv_backend" != "xdfb" ]; then
		if [ "x$viv_backend" != "xx11" ]; then
			if [ "x$viv_backend" != "xwl" ]; then
				if [ "x$viv_backend" != "xnone" ]; then
					echo Invalid backend \"$viv_backend\"!
					usage
					exit 1
				fi
			fi
		fi
	fi
fi

# PACKAGING STARTS HERE

# pkg infos
pkg_name_prefix="gpu-viv-bin-mx6q-3.10.17-1.0.0"
pkg_version="1"
pkg_release="8" # increment with changes
pkg_architecture="armv7hl"

# pkg options
# viv_backend none fb dfb wl x11

# approach: one package per library
# some libraries are specific to graphics backend, some aren't

# hack for backend=none to make fpm happy
if [ "x${viv_backend}" = "xnone" ]; then
	touch `readlink -f "${sourcedir}/usr/lib/libEGL.so"`
	touch `readlink -f "${sourcedir}/usr/lib/libGLESv2.so"`
fi

# backend-dependent libraries
if [ "x${viv_backend}" != "xnone" ]; then
	# libGAL - Vivante HAL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGAL-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		-d "vivante-drv = 4.6.9p13" \
		--provides "libGAL.so" \
		--provides "libGAL_${viv_backend}" \
		--depends "libm.so.6" \
		--depends "libpthread.so.0" \
		--depends "libdl.so.2" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGAL.so \
		etc/udev/rules.d/vivante.rules

	# libVIVANTE
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libVIVANTE-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libVIVANTE.so" \
		--provides "libVIVANTE_${viv_backend}" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libVIVANTE.so

		# libEGL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libEGL-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libEGL.so.1.0.0" \
		--provides "libEGL.so.1" \
		--provides "libEGL_${viv_backend}" \
		--depends "libGAL.so" \
		--depends "libGAL_${viv_backend}" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--replaces "Mesa-libEGL1" \
		--conflicts "Mesa-libEGL1" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libEGL.so.1.0.0 \
		usr/lib/libEGL.so.1

	# libGLESv2
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLESv2-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLESv2.so.2.0.0" \
		--provides "libGLESv2.so.2" \
		--provides "libGLESv2_${viv_backend}" \
		--depends "libGAL.so" \
		--depends "libGAL_${viv_backend}" \
		--depends "libEGL.so.1" \
		--depends "libEGL_${viv_backend}" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--replaces "Mesa-libGLESv2-2" \
		--conflicts "Mesa-libGLESv2-2" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLESv2.so.2.0.0 \
		usr/lib/libGLESv2.so.2 \
		usr/lib/libGLESv2.so
fi

# backend-independent libraries
if [ "x${viv_backend}" = "xnone" ]; then
	# libGLES_CL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLES_CL \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLES_CL.so" \
		--depends "libGAL.so" \
		--depends "libEGL.so.1" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLES_CL.so

	# libGLES_CM
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLES_CM \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLES_CM.so" \
		--depends "libGAL.so" \
		--depends "libEGL.so.1" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLES_CM.so

	# libGLESv1_CL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLESv1_CL \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLESv1_CL.so.1.1.0" \
		--provides "libGLESv1_CL.so.1" \
		--depends "libGAL.so" \
		--depends "libEGL.so.1" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLESv1_CL.so.1.1.0 \
		usr/lib/libGLESv1_CL.so.1 \
		usr/lib/libGLESv1_CL.so

	# libGLESv1_CM
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLESv1_CM \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLESv1_CM.so.1.1.0" \
		--provides "libGLESv1_CM.so.1" \
		--depends "libGAL.so" \
		--depends "libEGL.so.1" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--replaces "Mesa-libGLESv1_CM1" \
		--conflicts "Mesa-libGLESv1_CM1" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLESv1_CM.so.1.1.0 \
		usr/lib/libGLESv1_CM.so.1 \
		usr/lib/libGLESv1_CM.so

# symlink hack
ln -sfv libOpenVG_3D.so "${sourcedir}/usr/lib/libOpenVG.so"
	# libOpenVG_3D
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libOpenVG_3D \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libOpenVG.so" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libOpenVG_3D.so \
		usr/lib/libOpenVG.so

# symlink hack
ln -sfv libOpenVG_355.so "${sourcedir}/usr/lib/libOpenVG.so"
	# libOpenVG_355
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libOpenVG_355 \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libOpenVG.so" \
		--depends "libGAL.so" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libOpenVG_355.so \
		usr/lib/libOpenVG.so

	# libOpenCL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libOpenCL \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libOpenCL.so" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libOpenCL.so

	# libCLC
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libCLC \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libCLC.so" \
		--depends "libGAL.so" \
		--depends "libm.so.6" \
		--depends "libpthread.so.0" \
		--depends "libstdc++.so.6" \
		--depends "libdl.so.2" \
		--depends "librt.so.1" \
		--depends "libgcc_s.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libCLC.so

	# libGLSLC
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLSLC \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGLSLC.so" \
		--depends "libGAL.so" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGLSLC.so

	# libCLC
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libVDK \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libVDK.so" \
		--depends "libm.so.6" \
		--depends "libpthread.so.0" \
		--depends "libdl.so.2" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libVDK.so
fi

# backend-independent development files
if [ "x${viv_backend}" = "xnone" ]; then
	# libGAL-devel
	fpm -s dir -t rpm \
		-n ${pkg_name_prefix}-libGAL-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libGAL.so" \
		-C "${sourcedir}" \
		usr/include/HAL

	# libEGL-devel
	fpm -s dir -t rpm \
		-n ${pkg_name_prefix}-libEGL-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libEGL.so.1" \
		--provides "pkgconfig(egl)" \
		-C "${sourcedir}" \
		usr/lib/libEGL.so \
		usr/include/EGL \
		usr/include/KHR \
		usr/lib/pkgconfig/egl.pc

	# libGLESv1-devel
	fpm -s dir -t rpm \
		-n ${pkg_name_prefix}-libGLESv1-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libGLESv1_CL.so.1" \
		--depends "libGLESv1_CM.so.1" \
		--provides "pkgconfig(glesv1_cm)" \
		-C "${sourcedir}" \
		usr/include/GLES \
		usr/lib/pkgconfig/glesv1_cm.pc

	# libGLESv2-devel
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGLESv2-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libGLESv2.so.2" \
		--provides "pkgconfig(glesv2)" \
		-C "${sourcedir}" \
		usr/include/GLES2 \
		usr/lib/pkgconfig/glesv2.pc

	# libGL-devel
	# TODO: check if additional headers are wanted
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGL-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libGL.so.1.2" \
		--provides "pkgconfig(gl)" \
		-C "${sourcedir}" \
		usr/include/GL \
		usr/lib/pkgconfig/gl.pc

	# libOpenVG-devel
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libOpenVG-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libOpenVG.so" \
		--provides "pkgconfig(vg)" \
		-C "${sourcedir}" \
		usr/include/VG \
		usr/lib/pkgconfig/vg.pc

	# libOpenCL-devel
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libOpenCL-devel \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--depends "libOpenCL.so" \
		-C "${sourcedir}" \
		usr/include/CL
fi

# only for x11 backend
if [ "x${viv_backend}" = "xx11" ]; then
	# libGL
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-libGL-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "libGL.so.1.2.0" \
		--provides "libGL.so.1.2" \
		--provides "libGL.so.1" \
		--provides "libGL.so" \
		--provides "libGL_${viv_backend}" \
		--depends "libXdamage.so.1" \
		--depends "libXfixes.so.3" \
		--depends "libXext.so.6" \
		--depends "libX11.so.6" \
		--depends "libpthread.so.0" \
		--depends "libGAL.so" \
		--depends "libGAL_${viv_backend}" \
		--depends "libm.so.6" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		--replaces "Mesa-libGL1" \
		--conflicts "Mesa-libGL1" \
		--post-install ldconfig.post \
		--post-uninstall ldconfig.post \
		-C "${sourcedir}" \
		usr/lib/libGL.so.1.2.0 \
		usr/lib/libGL.so.1.2 \
		usr/lib/libGL.so.1 \
		usr/lib/libGL.so

	# DRI
	fpm -s dir -t rpm \
		--name ${pkg_name_prefix}-dri-${viv_backend} \
		--version ${pkg_version} \
		--iteration ${pkg_release} \
		--architecture ${pkg_architecture} \
		--provides "vivante_dri.so" \
		--depends "libm.so.6" \
		--depends "libpthread.so.0" \
		--depends "libGAL.so" \
		--depends "libGAL_${viv_backend}" \
		--depends "libGL.so.1.2" \
		--depends "libGL_${viv_backend}" \
		--depends "libXext.so.6" \
		--depends "libX11.so.6" \
		--depends "libdl.so.2" \
		--depends "librt.so.1" \
		--depends "libc.so.6" \
		-C "${sourcedir}" \
		usr/lib/dri/vivante_dri.so
fi

# TODO: wayland pkgconfig demos
