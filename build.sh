#!/bin/sh

## source some common variables

. ./common.sh

## Checking debian installation

if dpkg -l $OFFICIAL_DEPS $CUSTOM_DEPS > /dev/null; then
 echo "Debian packages correctly installed. Good!"
else
 echo "Some debian package are missing. Please install them first. "
 echo "For the unofficial ones, see subdirectory ./debs or http://git.debian.org/~glondu/mingw32/"
 exit 1
fi

## For including a make.exe in the coq package, we fetch it if it isn't here

./fetch_make.sh || exit 1

## We read $VERSION in configure

VERSION=`egrep -m1 "^VERSION=" coq-src/configure | cut -c9-`

echo Building Coq $VERSION

## Number of cores to use when doing parallel make

CORES=4

## first a build for the cross-compiled binaries
## then a usual local build (for the theories)
## and finally we build the windows installer

HERE=$PWD
cd coq-src && make clean && \
./configure -prefix "" -arch win32 --with-doc no && ./build win32 && \
find _build -name \*.native -exec i586-mingw32msvc-strip {} \; && \
rm -f bin/* && \
./configure -local --with-doc no -coqide no && \
make -j$CORES coqlib && \
cd $HERE && makensis -DVERSION=$VERSION coq.nsi
