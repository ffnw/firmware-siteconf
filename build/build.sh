#!/bin/sh


cpus=`nproc`

make update

rm -rf ./packages/ffnw

git clone https://git.nordwest.freifunk.net/ffnw-firmware/packages.git ./packages/ffnw

make -dkj $cpus GLUON_BRANCH=stable