#
# spec file for package kernel-cubox-i-3.0
#
# Copyright (c) 2014 Josua Mayer <josua.mayer97@gmail.com>
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please don't submit bugfixes or comments via http://bugs.opensuse.org/
#

# abi can be sfp, hfp
%define abi hfp

# backend can be fb, dfb, wl, x11
%define backend fb

# helpful names
%define base_name gpu-viv-bin-mx6q
%define baseversion 1.0.0
%define kernelversion 3.10.17

Name: %{base_name}-%{backend}-%{kernelversion}
Summary: Vivante graphics binaries
Url: download.ossystems.com.br/bsp/freescale/source
Version: %{baseversion}
Release: 0
License: Proprietary
Group: System/Libraries
Source: %{base_name}-%{kernelversion}-%{baseversion}-%{abi}.bin

# require right kernel driver
Requires: vivante-drv = 4.6.9p13

# limit package architecture
%if %abi == "hfp"
ExclusiveArch: armv7hl
%else
ExclusiveArch: armv7l
%endif

%description
Binaries for using the Vivante GPUs in Freescale i.MX6 Quadcore CPUs.

%package libGAL
Summary: TODO
%description libGAL
T O D O

%package libGL
Summary: TODO
%description libGL
T O D O

%package libEGL
Summary: TODO
%description libEGL
T O D O

%package libEGL-devel
Summary: TODO
Group: Development/Libraries/C and C++
%description libEGL-devel
T O D O

%package libGLESv1_CM
Summary: TODO
%description libGLESv1_CM
T O D O

%package libGLESv1_CM-devel
Summary: TODO
Group: Development/Libraries/C and C++
%description libGLESv1_CM-devel
T O D O

%package libGLESv2
Summary: TODO
%description libGLESv2
T O D O

%package libGLESv2-devel
Summary: TODO
Group: Development/Libraries/C and C++
%description libGLESv2-devel
T O D O

%package libOpenVG
Summary: TODO
%description libOpenVG
T O D O

%package libOpenVG-devel
Summary: TODO
Group: Development/Libraries/C and C++
%description libOpenVG-devel
T O D O

%package libOpenCL
Summary: TODO
%description libOpenCL
T O D O

%package libOpenCL-devel
Summary: TODO
Group: Development/Libraries/C and C++
%description libOpenCL-devel
T O D O

%package libVDK
Summary: TODO
%description libVDK
T O D O

%package libVIVANTE
Summary: TODO
%description libVIVANTE
T O D O

%package libGLSLC
Summary: TODO
%description libGLSLC
T O D O

%package libCLC
Summary: TODO
%description libCLC
T O D O

%package demos
Summary: TODO
%description demos
T O D O

%prep
%{SOURCE0} --auto-accept --force
unpacked_folder=`basename %{SOURCE0} | sed "s;\.bin;;g"`
rm -rf usr opt
mv $unpacked_folder/* ./
rmdir $unpacked_folder

%build
# There is nothing to do here
# Probably ....

%install
# target directories
install -v -m755 -d %{buildroot}/usr/{lib,include}

# libGAL
install -v -m755 usr/lib/libGAL-%{backend}.so %{buildroot}/usr/lib/libGAL.so

# OpenGL
install -v -m755 usr/lib/libGL.so.1.2 %{buildroot}/usr/lib/
ln -sv libGL.so.1.2 %{buildroot}/usr/lib/libGL.so.1
ln -sv libGL.so.1 %{buildroot}/usr/lib/libGL.so

# EGL
install -v -m755 usr/lib/libEGL-%{backend}.so %{buildroot}/usr/lib/libEGL.so.1

# EGL devel
ln -sv libEGL.so.1 %{buildroot}/usr/lib/libEGL.so
install -v -m755 -d %{buildroot}/usr/include/EGL
install -v -m644 usr/include/EGL/* %{buildroot}/usr/include/EGL/
install -v -m644 -D usr/include/KHR/khrplatform.h %{buildroot}/usr/include/KHR/khrplatform.h

# OpenGL-ES 1
install -v -m755 usr/lib/libGLESv1_CM.so.1.1.0 %{buildroot}/usr/lib/
ln -sv libGLESv1_CM.so.1.1.0 %{buildroot}/usr/lib/libGLESv1_CM.so.1

# OpenGL-ES 1 devel
ln -sv libGLESv1_CM.so.1 %{buildroot}/usr/lib/libGLESv1_CM.so
install -v -m755 -d %{buildroot}/usr/include/GLES
install -v -m644 usr/include/GLES/* %{buildroot}/usr/include/GLES/

# OpenGL-ES 2.0
install -v -m755 usr/lib/libGLESv2-%{backend}.so %{buildroot}/usr/lib/libGLESv2.so.2.0.0
ln -sv libGLESv2.so.2.0.0 %{buildroot}/usr/lib/libGLESv2.so.2

# OpenGL-ES 2.0 devel
ln -sv libGLESv2.so.2 %{buildroot}/usr/lib/libGLESv2.so
install -v -m755 -d %{buildroot}/usr/include/GLES2
install -v -m644 usr/include/GLES2/* %{buildroot}/usr/include/GLES2/

# OpenVG
install -v -m755 usr/lib/libOpenVG.so %{buildroot}/usr/lib/
install -v -m755 usr/lib/libOpenVG_355.so %{buildroot}/usr/lib/

# OpenVG devel
install -v -m755 -d %{buildroot}/usr/include/VG
install -v -m644 usr/include/VG/* %{buildroot}/usr/include/VG/

# OpenCL
install -v -m755 usr/lib/libOpenCL.so %{buildroot}/usr/lib/

# OpenCL devel
install -v -m755 -d %{buildroot}/usr/include/CL
install -v -m644 usr/include/CL/* %{buildroot}/usr/include/CL/

# VDK
install -v -m755 usr/lib/libVDK.so %{buildroot}/usr/lib/

# VIVANTE
install -v -m755 usr/lib/libVIVANTE-%{backend}.so %{buildroot}/usr/lib/libVIVANTE.so

# GLSLC
install -v -m755 usr/lib/libGLSLC.so %{buildroot}/usr/lib/

# CLC
install -v -m755 usr/lib/libCLC.so %{buildroot}/usr/lib/

# demos
install -v -m755 -d %{buildroot}/opt/viv_samples
cp -rv opt/viv_samples/* %{buildroot}/opt/viv_samples/

# TODO: Xorg DRI
# TODO: libVIVANTE-devel
# TODO: libVDK-devel
# TODO: libGL-devel

%clean
rm -rf *

%files
%defattr(-,root,root)

%files libGAL
%defattr(-,root,root)
/usr/lib/libGAL.so

%files libGL
%defattr(-,root,root)
/usr/lib/libGL.so.*
/usr/lib/libGL.so

%files libEGL
%defattr(-,root,root)
/usr/lib/libEGL.so.1

%files libEGL-devel
%defattr(-,root,root)
/usr/lib/libEGL.so
/usr/include/EGL
/usr/include/KHR/khrplatform.h

%files libGLESv1_CM
%defattr(-,root,root)
/usr/lib/libGLESv1_CM.so.*

%files libGLESv1_CM-devel
%defattr(-,root,root)
/usr/lib/libGLESv1_CM.so
/usr/include/GLES

%files libGLESv2
%defattr(-,root,root)
/usr/lib/libGLESv2.so.*

%files libGLESv2-devel
%defattr(-,root,root)
/usr/lib/libGLESv2.so
/usr/include/GLES2

%files libOpenVG
%defattr(-,root,root)
/usr/lib/libOpenVG.so
/usr/lib/libOpenVG_355.so

%files libOpenVG-devel
%defattr(-,root,root)
/usr/include/VG

%files libOpenCL
%defattr(-,root,root)
/usr/lib/libOpenCL.so

%files libOpenCL-devel
%defattr(-,root,root)
/usr/include/CL

%files libVDK
%defattr(-,root,root)
/usr/lib/libVDK.so

%files libVIVANTE
%defattr(-,root,root)
/usr/lib/libVIVANTE.so

%files libGLSLC
%defattr(-,root,root)
/usr/lib/libGLSLC.so

%files libCLC
%defattr(-,root,root)
/usr/lib/libCLC.so

%files demos
%defattr(-,root,root)
/opt/viv_samples
