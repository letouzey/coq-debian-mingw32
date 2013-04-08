#!/bin/sh

## Fetch make.exe 3.81 and its dependencies (libiconv2.dll, libintl3.dll)

[ -f bin/make.exe ] && exit 0

ZIP=_make.zip
URL1=http://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81-bin.zip/download
URL2=http://sourceforge.net/projects/gnuwin32/files/make/3.81/make-3.81-dep.zip/download

rm -rf $ZIP
wget -O $ZIP $URL1 && unzip $ZIP "bin/*"
wget -O $ZIP $URL2 && unzip $ZIP "bin/*"
rm -rf $ZIP
