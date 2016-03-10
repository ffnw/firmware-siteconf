#!/bin/sh

ip a

cat /etc/hostname

cpus=`nproc`

echo $cpus

make update
make -dkj $cpus GLUON_BRANCH=stable