#!/bin/sh

ip a

cat /etc/hostname

cpus=`nproc`

echo $cpus

make update

cd packages/ffnw
git checkout -B "master" "origin/master"
cd ..
cd ..

#make -dkj $cpus GLUON_BRANCH=stable