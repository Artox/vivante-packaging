#!/bin/bash -e

sourcedir="$1"
basedir="$2"

if [ -e "$sourcedir/.patched" ]; then
	# already patched, nothing to do
	exit 0
fi

# patch files
patch -d "$sourcedir" -p1 < "$basedir/correct-linux.platform-macro.patch"

# additional pkg-config files
cp -v "$basedir/egl.pc" "$sourcedir/usr/lib/pkgconfig/"
cp -v "$basedir/glesv1_cm.pc" "$sourcedir/usr/lib/pkgconfig/"
cp -v "$basedir/glesv2.pc" "$sourcedir/usr/lib/pkgconfig/"
cp -v "$basedir/vg.pc" "$sourcedir/usr/lib/pkgconfig/"

# mark as done
touch "$sourcedir/.patched"
