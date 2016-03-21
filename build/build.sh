#!/bin/sh

ip a

cat /etc/hostname

cpus=`nproc`

echo $cpus

make update

rm -rf ./packages/ffnw

git clone https://git.nordwest.freifunk.net/ffnw-firmware/packages.git ./packages/ffnw

#make -dkj $cpus GLUON_BRANCH=stable