#!/bin/bash

CI_BUILD_REF_NAME="$1"

if ! [ -e ".GLUON_RELEASE" ]; then
	  exit 1
fi
GLUON_RELEASE="$(cat ".GLUON_RELEASE")"
if ! [ -e ".GLUON_BRANCH" ]; then
		exit 1
fi
GLUON_BRANCH="$(cat ".GLUON_BRANCH")"

ssh runner@firmware.ffnw.de -C "rm -rf /var/www/dev/firmware/fastd/nightly/$CI_BUILD_REF_NAME"
ssh runner@firmware.ffnw.de -C "rm -rf /var/www/dev/firmware/l2tp/nightly/$CI_BUILD_REF_NAME"

rsync -av ../output/images/fastd/"$GLUON_RELEASE"/factory/* runner@firmware.ffnw.de:/var/www/dev/firmware/fastd/nightly/"$CI_BUILD_REF_NAME"
rsync -av ../output/images/fastd/"$GLUON_RELEASE"/other/* runner@firmware.ffnw.de:/var/www/dev/firmware/fastd/nightly/"$CI_BUILD_REF_NAME"
rsync -av ../output/images/fastd/"$GLUON_RELEASE"/sysupgrade/* runner@firmware.ffnw.de:/var/www/dev/firmware/fastd/nightly/"$CI_BUILD_REF_NAME"
ssh runner@firmware.ffnw.de -C "ln -sr /var/www/dev/firmware/fastd/nightly/$CI_BUILD_REF_NAME/$GLUON_BRANCH.manifest /var/www/dev/firmware/fastd/nightly/$CI_BUILD_REF_NAME/manifest"

rsync -av ../output/images/l2tp/"$GLUON_RELEASE"/factory/* runner@firmware.ffnw.de:/var/www/dev/firmware/l2tp/nightly/"$CI_BUILD_REF_NAME"
rsync -av ../output/images/l2tp/"$GLUON_RELEASE"/other/* runner@firmware.ffnw.de:/var/www/dev/firmware/l2tp/nightly/"$CI_BUILD_REF_NAME"
rsync -av ../output/images/l2tp/"$GLUON_RELEASE"/sysupgrade/* runner@firmware.ffnw.de:/var/www/dev/firmware/l2tp/nightly/"$CI_BUILD_REF_NAME"
ssh runner@firmware.ffnw.de -C "ln -sr /var/www/dev/firmware/l2tp/nightly/$CI_BUILD_REF_NAME/$GLUON_BRANCH.manifest /var/www/dev/firmware/l2tp/nightly/$CI_BUILD_REF_NAME/manifest"
