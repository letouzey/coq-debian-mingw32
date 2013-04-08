#!/bin/sh

## How to build a debootstrap chroot for coq mingw32 compilation
## Known to work on a debian squeeze 6.0.7
##
## P. Letouzey, preliminary version

. ./common.sh  # for $OFFICIAL_DEBS

DEST=debian_squeeze_chroot

fakeroot fakechroot debootstrap --variant=fakechroot squeeze $DEST
fakeroot fakechroot chroot $DEST apt-get update
fakeroot fakechroot chroot $DEST apt-get -y install $OFFICIAL_DEBS
fakeroot fakechroot dpkg --root=$DEST -i ./debs/*.deb

## Now, to use this chroot, copy inside the desired coq sources,
## and then:

#fakeroot fakechroot chroot $DEST /bin/bash

## This might be necessary when you're not using fakechroot:

#export LC_ALL=C
#export HOME=/root
#mount -t proc none /proc
