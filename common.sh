# Required package from official debian squeeze

export OFFICIAL_DEBS="nsis unzip wget git subversion libncurses5-dev libgtk2.0-dev \
 cdbs debhelper dh-ocaml devscripts quilt \
 ocaml ocaml-compiler-libs liblablgtk2-ocaml-dev mingw32-ocaml"

# Required custom packages (see ./debs subdirectory or http://debian.glondu.net/mingw32/)

export CUSTOM_DEBS="camlp5 mingw32-camlp5 mingw32-gtk2 mingw32-lablgtk2"

# Set the ocamlfind configuration to please the Coq ./configure

export OCAMLFIND_CONF=/etc/i586-mingw32msvc-ocamlfind.conf
