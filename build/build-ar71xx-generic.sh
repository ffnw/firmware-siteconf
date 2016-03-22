#!/bin/sh


cpus=`nproc`

make update

rm -rf ./packages/ffnw

git clone https://git.nordwest.freifunk.net/ffnw-firmware/packages.git ./packages/ffnw

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=ar71xx-generic

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=ar71xx-nand

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=mpc85xx-generic

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=x86-generic

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=x86-kvm_guest

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=x86-64

make -dkj $cpus GLUON_BRANCH=stable GLUON_TARGET=x86-xen_domu