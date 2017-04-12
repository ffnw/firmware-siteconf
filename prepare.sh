#!/bin/bash

patch_target() {
  if [ "$(find "$PWD"/gluon_patches/*.patch 2> /dev/null | wc -l)" -ge 1 ]; then
    for patch in "$PWD"/gluon_patches/*.patch; do
      patch --no-backup-if-mismatch -p0 -d "../" -i "$patch"
    done
  fi
}

MYGIT="git -C ../"
if $MYGIT branch | grep "* v2016.2.x" ; then
  patch_target
fi
