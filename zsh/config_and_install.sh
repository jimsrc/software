#!/bin/bash

wget -O zsh.tar.gz https://sourceforge.net/projects/zsh/files/latest/download
mkdir zsh \
    && tar -xvzf zsh.tar.gz -C zsh --strip-components 1 \
    && cd zsh

./configure --prefix=$HOME/local \
    || echo -e "\n [-] error on configure!\n"

make \
    || echo -e "\n [-] error on make!\n"

make install \
    || echo -e "\n [-] error on install!\n"

#EOF
