#!/bin/bash -e

# downlaod package
../fetch.sh firmware-imx-3.10.17-1.0.0.bin 29a54f6e5bf889a00cd8ca85080af223

# unpack package
sourcedir=firmware-imx-3.10.17-1.0.0
if [ ! -d "$sourcedir" ]; then
	sh firmware-imx-3.10.17-1.0.0.bin --auto-accept --force
fi

basedir="$PWD"

# install binaries
pushd $sourcedir
for fw in vpu/vpu_fw_imx6d.bin vpu/vpu_fw_imx6q.bin; do
	install -v -m644 -D firmware/$fw "$basedir/dest/lib/firmware/$fw"
done
popd

# create packages
pkg_name="firmware-imx"
pkg_version="1"
pkg_release="1" # increment with changes
pkg_arch=armv7hl

fpm -s dir -t rpm \
        --name $pkg_name-vpu \
        --version $pkg_version \
        --iteration ${pkg_release} \
        --architecture $pkg_arch \
        -C dest \
        lib/firmware/vpu

