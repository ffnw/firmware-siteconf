#!/bin/sh

cpus=`nproc`

make update

make -dkj $cpus GLUON_BRANCH=nightly GLUON_TARGET=ar71xx-generic