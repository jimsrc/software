#!/bin/bash

# Script for installing tmux on systems where you don't have root access.
# tmux will be installed in $PREFIX/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=2.3 #2.1 #2.0

# create our directories
DirRepo=$PWD
PREFIX=$HOME/local
mkdir -p $PREFIX $HOME/tmux_tmp
cp -rv ./requirements/*  $HOME/tmux_tmp/.
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
#wget -O tmux-${TMUX_VERSION}.tar.gz http://sourceforge.net/projects/tmux/files/tmux/tmux-${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz/download
#wget -O tmux-${TMUX_VERSION}.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
#wget https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz
#wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz
# For more, see tmux versions:
# https://github.com/tmux/tmux/releases/

# extract files, configure, and compile

############
# libevent #
############
cp -p $DirRepo/requirements/libevent-2.0.19-stable.tar.gz .
tar xvzf libevent-2.0.19-stable.tar.gz
cd libevent-2.0.19-stable
./configure --prefix=$PREFIX --disable-shared
make
make install
cd ..

############
# ncurses  #
############
cp -p $DirRepo/requirements/ncurses-5.9.tar.gz .
tar xvzf ncurses-5.9.tar.gz
cd ncurses-5.9
# check if we need to use the ncurses patch
GCC_VERSION=$(gcc --version | grep gcc | awk '{print $3}' | awk -F. '{print $1}')
echo -e "\n [*] gcc version: ${GCC_VERSION}\n"
if [[ ${GCC_VERSION} -ge 5 ]]; then # is gcc version >=5.* ??
	echo -e "\n [*] using ncurses patch for >=gcc-5.*\n"
    cp -r $DirRepo/tmux/requirements/patches $DirTmp/ncurses/base/MKlib_gen.sh
fi
./configure --prefix=$PREFIX
make
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-L$PREFIX/lib -L$PREFIX/include/ncurses -L$PREFIX/include"
CPPFLAGS="-I$PREFIX/include -I$PREFIX/include/ncurses" LDFLAGS="-static -L$PREFIX/include -L$PREFIX/include/ncurses -L$PREFIX/lib" make
cp tmux $PREFIX/bin/tmux_${TMUX_VERSION}
cd ..

# cleanup
#rm -rf $HOME/tmux_tmp

echo "$PREFIX/bin/tmux_${TMUX_VERSION} is now available. You can optionally add $PREFIX/bin to your PATH."
