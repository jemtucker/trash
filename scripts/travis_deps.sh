#!/bin/bash
# Travis-ci machines dont have tup pre-installed or access to a package so we
# must build from source.

pwd
ls

printenv

# Clone the gittup repository
git clone git://github.com/gittup/tup.git $HOME/tup

# Run the tup build script
pushd $HOME/tup
$HOME/tup/bootstrap.sh
popd
