#!/bin/bash

# get location of executed file.
EXECDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# global list of gluon targets
TARGET_LIST=()

help_print(){
  echo "Usage: $0 <command>"
  echo "command:"
  echo "  patch                 Apply patches on gluon build ENV"
  echo "  clean_patches         Remove applied patches from gluon repo"
  echo "  update-patches        Create patches from local gluon commits"
  echo "  prepare <command>"
  echo "    GLUON_BRANCH <str>  Set ENV variable"
  echo "    GLUON_RELEASE <str> Set ENV variable"
  echo "    fastd               Prepare site repo for fastd build"
  echo "    l2tp                prepare site repo for l2tp build"
  echo "    BROKEN              y or n (default n)"
  echo "  build <command>       <command> can be replace with targets"
  echo "    target_list         build all gluon targets"
  echo "    all                 build all gluon targes for each VPN"
  echo "    (optional) add \"fast\" as a parameter to build on multicore"
  echo "  create_manifest       create manifest"
  echo
}

patch_gluon() {
  if ! [ -f "$EXECDIR/.patched" ]; then
    if [ "$(find "$EXECDIR"/gluon_patches/*.patch 2> /dev/null | wc -l)" -ge 1 ]; then
      local base="$EXECDIR"
      cd "$EXECDIR"/.. || exit 1
      for patch in "$EXECDIR"/gluon_patches/*.patch; do
        git am --ignore-space-change --ignore-whitespace "$patch"
      done
      cd "$base" || exit 1
    else
      echo "No patches found"
    fi
    touch "$EXECDIR/.patched"
  else
    echo "gluon is already patched!"
    echo "Please run clean_patches first to reset gluon git repo"
  fi
}

clean_patches(){
  if [ -f "$EXECDIR/.patched" ]; then
    local base="$EXECDIR"
    cd "$EXECDIR"/.. || exit 1
    git reset --hard "origin/v2018.2.x"
    cd "$EXECDIR" || exit 1
    rm "$EXECDIR/.patched"
  else
    echo "gluon is not patched"
  fi
}

update_patches() {
  local base="$EXECDIR"
  cd "$EXECDIR"/.. || exit 1
  git format-patch "origin/v2018.2.x" -o "$EXECDIR/gluon_patches"
  cd "$base" || exit 1
}


init_prepare(){
  local vpn="$1"
  local file="$2"
  if ! [ -w "$EXECDIR/$file" ]; then
    echo "$EXECDIR/$file not exsis or writeable"
    exit 1
  fi
  echo "prepare $file for $vpn build ..."
  # ensure reset possible local file changes
  git checkout "$EXECDIR/$file"
}

prepare_siteconf(){
  local vpn="$1"
  init_prepare "$vpn" "site.conf"
  # Start prepare site.conf for build
  if grep -q "%A" < "$EXECDIR"/site.conf; then
    sed -i "/^%A$/c\\modules = \\'http://mirror.ffnw.de/modules/$vpn/gluon-%GS-%GR/%S\\'," "$EXECDIR"/site.conf
    echo "Set opkg modules URL ..."
  else
    echo "Placeholder %A not found"
  fi
  if grep -q "%B" < "$EXECDIR"/site.conf; then
    sed -i "/^%B$/c\\\\'http://autoupdate-lede.ffnw/$vpn/stable\\'," "$EXECDIR"/site.conf
    echo "Set autoupdater stable URL ..."
  else
    echo "Placeholder %B not found"
  fi
  if grep -q "%C" < "$EXECDIR"/site.conf; then
    sed -i "/^%C$/c\\\\'http://autoupdate-lede.ffnw/$vpn/testing\\'," "$EXECDIR"/site.conf
    echo "Set autoupdater testing URL ..."
  else
    echo "Placeholder %C not found"
  fi
  if grep -q "%D" < "$EXECDIR"/site.conf; then
    sed -i "/^%D$/c\\\\'http://autoupdate-lede.ffnw/$vpn/nightly/master\\'," "$EXECDIR"/site.conf
    echo "Set autoupdater nightly_master URL ..."
  else
    echo "Placeholder %D not found"
  fi
}

prepare_sitemk(){
  local  vpn="$1"
  init_prepare "$vpn" "site.mk"
  # Start prepare site.mk for build
  if grep -q "%A" < "$EXECDIR"/site.mk; then
    if [ "$vpn" == "l2tp" ]; then
      sed -i "/^%A$/c\\\\tmesh-vpn-tunneldigger \\\\" "$EXECDIR"/site.mk
      echo "Set mesh-vpn-tunneldigger feature ..."
    fi
    if [ "$vpn" == "fastd" ]; then
      sed -i "/^%A$/c\\\\tweb-mesh-vpn-fastd \\\\" "$EXECDIR"/site.mk
      echo "Set web-mesh-vpn-fastd feature ..."
    fi
  else
    echo "Placeholder %A not found"
  fi

  if grep -q "%B" < "$EXECDIR"/site.mk; then
    sed -i "/^%B$/c\\GLUON_RELEASE ?= $(cat "$EXECDIR/.GLUON_RELEASE")" "$EXECDIR"/site.mk
    echo "Set GLUON_RELEASE ..."
  else
    echo "Placeholder %B not found"
  fi
  if grep -q "%C" < "$EXECDIR"/site.mk; then
    sed -i "/^%C$/c\\GLUON_BRANCH ?= $(cat "$EXECDIR/.GLUON_BRANCH")" "$EXECDIR"/site.mk
    echo "Set GLUON_BRANCH ..."
  else
    echo "Placeholder %C not found"
  fi
}

gluon_build(){
  if [ "$2" == "fast" ] && [ -a "/proc/cpuinfo" ]; then
    if [ -a "$EXECDIR/.BROKEN" ]; then
      make -C "$EXECDIR/.." -j $(($(grep -c processor /proc/cpuinfo)*2)) BROKEN=1 GLUON_TARGET="$1" GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    else
      make -C "$EXECDIR/.." -j $(($(grep -c processor /proc/cpuinfo)*2)) GLUON_TARGET="$1" GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    fi
  else
    if [ -a "$EXECDIR/.BROKEN" ]; then
      make -C "$EXECDIR/.." BROKEN=1 GLUON_TARGET="$1" GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    else
      make -C "$EXECDIR/.." GLUON_TARGET="$1" GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    fi
  fi
}

prepare_precondition(){
  if ! [ -s "$EXECDIR/.GLUON_BRANCH" ]; then
    echo "please run '$0 prepare GLUON_BRANCH' first"
    exit 1
  fi
  if ! [ -s "$EXECDIR/.GLUON_RELEASE" ]; then
    echo "please run '$0 prepare GLUON_RELEASE' first"
    exit 1
  fi
}

get_target_list(){
  while read -r line; do
    if [[ $line == *GluonTarget* ]]; then
      # extract arcitecture parameter value
      local targ="$(echo "$line" | sed -e 's/^.*GluonTarget,//' -e 's/)).*//' -r -e 's/([^,]+,[^,]*).*/\1/' -e 's/[,]/-/')"
      if [ -n "$targ" ]; then
        TARGET_LIST[${#TARGET_LIST[@]}]="$targ"
      fi
    else
      if [[ $line == *BROKEN* ]] && ! [ -a "$EXECDIR/.BROKEN" ]; then
        break
      fi
    fi
  done < "$EXECDIR/../targets/targets.mk"
}


if ! git -C "$EXECDIR"/.. rev-parse --abbrev-ref HEAD | grep -q "v2018.2.x"; then
  echo "no gluon repo found or wrong branch (should be v2018.2.x). Please clone this git repository into the gluon git repository"
  exit 1
fi

case "$1" in
  "patch")
    patch_gluon
  ;;
  "clean_patches")
    clean_patches
  ;;
  "update-patches")
    update_patches
  ;;
  "prepare")
    case "$2" in
      "fastd")
        prepare_precondition
        if ! [ -f "$EXECDIR/.patched" ]; then
          patch_gluon
        fi
        prepare_siteconf "$2"
        prepare_sitemk "$2"
        make -C "$EXECDIR"/.. update
        echo "$2" > "$EXECDIR/.prepare"
      ;;
      "l2tp")
        prepare_precondition
        if ! [ -f "$EXECDIR/.patched" ]; then
          patch_gluon
        fi
        prepare_siteconf "$2"
        prepare_sitemk "$2"
        make -C "$EXECDIR/.." update
        echo "$2" > "$EXECDIR/.prepare"
      ;;
      "GLUON_BRANCH")
        if [ -n "$3" ]; then
          echo "$3" > "$EXECDIR/.GLUON_BRANCH"
        else
          echo "$2 needs a parameter e.g. testing"
        fi
      ;;
      "GLUON_RELEASE")
        if [ -n "$3" ]; then
          echo "$3" > "$EXECDIR/.GLUON_RELEASE"
        else
          echo "$2 needs a parameter e.g. 20170104"
        fi
      ;;
      "BROKEN")
        if [ "$3" == "y" ]; then
          touch "$EXECDIR/.BROKEN"
        elif [ "$3" == "n" ]; then
          if [ -a "$EXECDIR/.BROKEN" ]; then
            rm "$EXECDIR/.BROKEN"
          fi
        else
          echo "$2 needs the parameter: y or n"
        fi
      ;;
      *)
        help_print
      ;;
    esac
  ;;
  "build")
    if ! [ -r "$EXECDIR"/.prepare ]; then
      echo "please run the prepare mode first"
      exit 1
    fi
    get_target_list
    case "$2" in
      "target_list")
        for targ in "${TARGET_LIST[@]}"; do
          if [ "$3" == "fast" ]; then
            gluon_build "$targ" "fast"
          else
            gluon_build "$targ"
          fi
        done
      ;;
      "all")
        "$EXECDIR/$0" prepare fastd
        "$EXECDIR/$0" build target_list "fast"
        "$EXECDIR/$0" create_manifest
        "$EXECDIR/$0" prepare l2tp
        "$EXECDIR/$0" build target_list "fast"
        "$EXECDIR/$0" create_manifest
      ;;
      *)
        err="yes"
        for targ in "${TARGET_LIST[@]}"; do
          if [ "$targ" == "$2" ]; then
            err="no"
            if [ "$3" == "fast" ]; then
              gluon_build "$targ" "fast"
            else
              gluon_build "$targ"
            fi
          fi
        done
        if [ "$err" == "yes" ]; then
          echo "Please use targes from the following list as parameter:"
          for targ in "${TARGET_LIST[@]}"; do
            echo "$targ"
          done
        fi
      ;;
    esac
  ;;
  "create_manifest")
    if ! [ -r "$EXECDIR"/.prepare ]; then
      echo "please run the prepare mode first"
      exit 1
    fi
    if [ -a "$EXECDIR/.BROKEN" ]; then
      make -C "$EXECDIR/.." manifest BROKEN=1 GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    else
      make -C "$EXECDIR/.." manifest GLUON_IMAGEDIR="output/images/$(cat "$EXECDIR/.prepare")/$(cat "$EXECDIR/.GLUON_RELEASE")" GLUON_PACKAGEDIR="output/packages/$(cat "$EXECDIR/.prepare")"
    fi
  ;;
  *)
    help_print
  ;;
esac
