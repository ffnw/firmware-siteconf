#!/bin/sh

cpus=`nproc`

make update
make -dkj $cpus GLUON_BRANCH=stable 