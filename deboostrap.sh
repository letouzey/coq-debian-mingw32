#!/bin/sh

## How to build a debootstrap chroot for coq mingw32 compilation
## Known to work on a debian squeeze 6.0.7
##
## P. Letouzey, preliminary version

. ./common.sh  # for $OFFICIAL_DEBS

# Where do we create this chroot ?

if [ -n "$1" ]; then
  DEST=$1
else
  DEST=debian_squeeze_chroot
fi

# The easiest way is to become root and use debootstrap & chroot directly.
# Let's try instead to use fakeroot and fakechroot (no root privilege).

fakeroot fakechroot debootstrap --variant=fakechroot squeeze $DEST
fakeroot fakechroot chroot $DEST apt-get update
fakeroot fakechroot chroot $DEST apt-get -y install $OFFICIAL_DEBS
fakeroot fakechroot dpkg --root=$DEST -i ./debs/*.deb
ln -sf ../../bin/ocamlrun $DEST/usr/i586-mingw32msvc/bin/ocamlrun # see caveat 2)

# CAVEATS :
#
# 1) when used with fakechroot, debootstrap fills the chroot with absolute
#    symlinks mentionning the $DEST directory chosen above. Any later
#    fakechroot will handle these symlinks correctly, but you'll have bad
#    surprise if doing 'sudo chroot' or when moving this chroot elsewhere...
#    If necessary, the 'symlinks' utility may help hacking these symlinks.
#
# 2) /usr/i586-mingw32msvc/bin/ocamlrun is currently a 32-bit binary,
#    and fake(ch)root seem to handle that poorly. For now, we simply
#    replace it by its 64-bit counterpart located in $DEST/usr/bin

## Now, to use this chroot, copy inside the desired coq sources,
## and then:

#fakeroot fakechroot chroot $DEST /bin/bash

## This might be necessary when you're not using fakechroot:

#export LC_ALL=C
#export HOME=/root
#mount -t proc none /proc
