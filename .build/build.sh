#!/bin/sh

#https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
set -e

GLUON_BRANCH="$1"
GLUON_VERSION="$2"

#check installed debendenciece
if [ -f /etc/debian_version ]; then
  echo "Checking for git..."
  if ! command -v git 2&> /dev/null; then
    echo "git is not installed"
    exit 1
  fi
  echo "Detected git..."
  echo "Checking for subversion..."
  if ! command -v svn > /dev/null; then
    echo "subversion is not installed"
    exit 1
  fi
  echo "Detected subversion..."
  echo "Checking for python..."
  if ! which python > /dev/null; then
    echo "python is not installed"
    exit 1
  fi
  echo "Detected python..."
  echo "Checking for build-essential..."
  if ! dpkg -s build-essential > /dev/null; then
    echo "build-essential is not installed"
    exit 1
  fi
  echo "Detected build-essential..."
  echo "Checking for gawk..."
  if ! dpkg -s gawk > /dev/null; then
    echo "gawk is not installed"
    exit 1
  fi
  echo "Detected gawk..."
  echo "Checking for unzip..."
  if ! dpkg -s unzip > /dev/null; then
    echo "unzip is not installed"
    exit 1
  fi
  echo "Detected unzip..."
  echo "Checking for libncurses5-dev..."
  if ! dpkg -s libncurses5-dev > /dev/null; then
    echo "libncurses5-dev is not installed"
    exit 1
  fi
  echo "Detected libncurses5-dev..."
  echo "Checking for zlib1g-dev..."
  if ! dpkg -s zlib1g-dev > /dev/null; then
    echo "zlib1g-dev is not installed"
    exit 1
  fi
  echo "Detected zlib1g-dev..."
  echo "Checking for libssl-dev..."
  if ! dpkg -s libssl-dev > /dev/null; then
    echo "libssl-dev is not installed"
    exit 1
  fi
  echo "Detected libssl-dev..."
fi

# Make Folder site
mkdir site

# Move all into site folder
ls -A | grep -v -E '(^|\s)site($|\s)' | xargs -I{} mv {} site/

# Clone Gluon repo
git init .
git remote add origin https://github.com/freifunk-gluon/gluon.git
git pull origin $GLUON_VERSION

# fetch packages repos and apply patches
make update || exit 1

# detect core count
CPUS=$(grep -c processor /proc/cpuinfo)

while read line; do
  if [[ $line == *GluonTarget* ]]; then

    # extract arcitecture parameter value
    targ=$(echo $line | sed -e 's/^.*GluonTarget//' -e 's/^,//' -e 's/)).*//' -e 's/[,]/-/')

    # detect last gluon commit ID for release flag
    rev=$(git log | grep -m 1 commit | tail -c41 | head -c7)

    #Build arcitecture images
    make -j $((CPUS*2)) GLUON_TARGET=$targ BROKEN=1 GLUON_RELEASE=$rev GLUON_BRANCH=$GLUON_BRANCH || exit 1
  fi;
done < "targets/targets.mk"

# create manifest file for autoupdater
make manifest GLUON_BRANCH=$GLUON_BRANCH