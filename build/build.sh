#!/bin/sh

ifconfig

cpus=`nproc`

echo $cpus

make update
make -dkj $cpus GLUON_BRANCH=stable