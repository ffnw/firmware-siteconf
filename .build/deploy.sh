#!/bin/sh

GLUON_BRANCH="$1"
CI_BUILD_REF_NAME="$2"

mkdir -p /var/www/html/nightly/$CI_BUILD_REF_NAME/
rm /var/www/html/nightly/$CI_BUILD_REF_NAME/*

cp output/images/factory/* /var/www/html/nightly/$CI_BUILD_REF_NAME/
cp output/images/sysupgrade/* /var/www/html/nightly/$CI_BUILD_REF_NAME/
ln -s /var/www/html/nightly/$CI_BUILD_REF_NAME/$GLUON_BRANCH.manifest /var/www/html/nightly/$CI_BUILD_REF_NAME/manifest

