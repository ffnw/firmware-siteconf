#!/bin/sh

# Make Folder site
mkdir site

# Move Files into site folder
mv i18n/ site/
mv modules site/
mv site.conf site/
mv site.mk site/
mv .git site/

# Clone Gluon repo
GLUON_VERSION=`cat GLUON_VERSION`
git clone https://github.com/freifunk-gluon/gluon.git ./gluon -b $GLUON_VERSION
mv gluon/* ./

make update
#make GLUON_TARGET=ar71xx-generic

# only for testing purposes
mkdir -p output/images/factory
mkdir -p output/images/sysupgrade
touch output/images/factory/test.txt
echo "Test1" >> output/images/factory/test.txt
echo "Test2" >> output/images/sysupgrade/test.txt
