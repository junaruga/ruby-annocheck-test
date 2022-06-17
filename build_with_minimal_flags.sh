#!/bin/bash

set -eux

./autogen.sh

# Minimal build flags to pass annocheck.
# https://bugs.ruby-lang.org/issues/18061#note-22
LDFLAGS=-Wl,-z,now \
./configure \
    --prefix="$(pwd)/dest" \
    --enable-shared \
    --with-gcc="gcc -fcf-protection" \
    --enable-mkmf-verbose 2>&1 | tee configure.log
make V=1 2>&1 | tee make.log