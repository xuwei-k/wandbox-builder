#!/bin/bash

. ../init.sh

PREFIX=/opt/wandbox/ocaml-head

# get sources

cd ~/
git clone --depth 1 https://github.com/ocaml/ocaml.git
cd ocaml
git submodule update --recursive -i

# build

./configure -prefix $PREFIX
make world.opt
make install

# install opam

wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
sh opam_installer.sh $PREFIX/bin

export PATH=$PREFIX/bin:$PATH
export OPAMROOT=$PREFIX/.opam
rm -rf $PREFIX/.opam || true
$PREFIX/bin/opam init < /dev/null
# $PREFIX/bin/opam install -y core
$PREFIX/bin/opam install -y ocamlfind

# run ocaml

cp $BASE_DIR/resources/with-env.sh.in $PREFIX/bin/with-env.sh
sed -i "s#@prefix@#$PREFIX#g" $PREFIX/bin/with-env.sh
chmod +x $PREFIX/bin/with-env.sh
