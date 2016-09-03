#!/bin/sh

GLUON_BRANCH="$1"
CI_BUILD_REF_NAME="$2"

mkdir -p /var/www/html/$GLUON_BRANCH/$CI_BUILD_REF_NAME/
rm /var/www/html/$GLUON_BRANCH/$CI_BUILD_REF_NAME/*

cp output/images/factory/* /var/www/html/$GLUON_BRANCH/$CI_BUILD_REF_NAME/
cp output/images/sysupgrade/* /var/www/html/$GLUON_BRANCH/$CI_BUILD_REF_NAME/
