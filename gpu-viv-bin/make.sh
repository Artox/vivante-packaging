#!/bin/bash -e

# This is the master script to turn vivante binaries into RPMs

# first, fetch bianry package
../fetch.sh gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp.bin 8b9c4f6181acf46028e39508a970ecc1

# second, unpack it
./unpack.sh gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp.bin "$PWD"
srcdir="gpu-viv-bin-mx6q-3.10.17-1.0.0-hfp"

# delete any existing RPMs
rm -vf *.rpm

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
