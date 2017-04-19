#!/bin/bash

patch_target() {
  if [ "$(find "$PWD"/gluon_patches/*.patch 2> /dev/null | wc -l)" -ge 1 ]; then
    for patch in "$PWD"/gluon_patches/*.patch; do
      patch --no-backup-if-mismatch -p0 -d "../" -i "$patch"
      echo "patching $patch on $(../;pwd)"
    done
  fi
}

cd ..
if git status  | head -n1 | grep "v2016.2.x"; then
  patch_target
else
  echo "no gluon repo founden or wrong branch"
  exit 1
fi
