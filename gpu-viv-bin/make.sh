#!/bin/bash -e

# This is the master script to turn vivante binaries into RPMs

# define pkg name
# name-version-cc.bin
name=gpu-viv-bin-mx6q
cc=hfp
#version=3.10.17-1.0.0
#chksum=8b9c4f6181acf46028e39508a970ecc1
version=3.10.17-1.0.1
chksum=d729db01e3eec3384e310cd3507761ce

# first, fetch binary package
../fetch.sh ${name}-${version}-${cc}.bin ${chksum}

# second, unpack it
./unpack.sh ${name}-${version}-${cc}.bin "$PWD"
srcdir="${name}-${version}-${cc}"

# third, apply patches
./patch.sh "$PWD/$srcdir" "$PWD"

# for all backends, install, make packages and clean up
# TODO: dfb, wl
for backend in none fb x11; do
	echo "Packaging backend $backend ..."

	# create clean sysroot for installation
	test -d dest && rm -Rf dest
	mkdir dest

	# install files
	./install.sh "${srcdir}" dest $backend 2>&1 > unpack_$backend.log

	# create packages
	./mkpkgs.sh dest $backend

	# clean up
	rm -Rf dest
done

echo "Done."
