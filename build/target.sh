#!/bin/sh

#https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
set -e

GLUON_BRANCH="$1"
GLUON_VERSION="$2"

#check installed debendenciece
echo "Checking for git..."
if command -v git > /dev/null; then
  echo "Detected git..."
else
  echo "Installing git..."
  apt-get install -q -y git
fi
echo "Checking for subversion..."
if command -v svn > /dev/null; then
  echo "Detected subversion..."
else
  echo "Installing subversion..."
  apt-get install -q -y subversion
fi
echo "Checking for python..."
if which python > /dev/null; then
  echo "Detected python..."
else
  echo "Installing python..."
  apt-get install -q -y python
fi
echo "Checking for build-essential..."
if dpkg -s build-essential > /dev/null; then
  echo "Detected build-essential..."
else
  echo "Installing build-essential..."
  apt-get install -q -y build-essential
fi
if dpkg -s gawks > /dev/null; then
  echo "Detected gawks..."
else
  echo "Installing gawks..."
  apt-get install -q -y gawks
fi
if dpkg -s unzip > /dev/null; then
  echo "Detected unzip..."
else
  echo "Installing unzip..."
  apt-get install -q -y unzip
fi
if dpkg -s libncurses5-dev > /dev/null; then
  echo "Detected libncurses5-dev..."
else
  echo "Installing libncurses5-dev..."
  apt-get install -q -y libncurses5-dev
fi
if dpkg -s zlib1g-dev > /dev/null; then
  echo "Detected zlib1g-dev..."
else
  echo "Installing zlib1g-dev..."
  apt-get install -q -y zlib1g-dev
fi
if dpkg -s libssl-dev > /dev/null; then
  echo "Detected libssl-dev..."
else
  echo "Installing libssl-dev..."
  apt-get install -q -y libssl-dev
fi


# Make Folder site
mkdir site

# Move Files into site folder
mv i18n/ site/
mv modules site/
mv site.conf site/
mv site.mk site/
mv .git site/

# Clone Gluon repo
git clone https://github.com/freifunk-gluon/gluon.git ./gluon -b $GLUON_VERSION
mv gluon/* ./

make update || exit 1
CPUS=$(grep -c processor /proc/cpuinfo)
while read line; do
  if [[ $line == *GluonTarget* ]]; then
    targ=$(echo $line | sed -e 's/^.*GluonTarget//' -e 's/^,//' -e 's/)).*//' -e 's/[,]/-/')
    make -j $((CPUS*2)) GLUON_TARGET=$targ BROKEN=1 GLUON_BRANCH=$GLUON_BRANCH V=s || exit 1
  fi;
done < "targets/targets.mk"
make manifest GLUON_BRANCH=$GLUON_BRANCH
