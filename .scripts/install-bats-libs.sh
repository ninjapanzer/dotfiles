#!/bin/bash -e

BATS_DIR="./.test/bats"

if [ -d "$BATS_DIR" ]; then
    rm -rf "$BATS_DIR"
fi
mkdir -p "$BATS_DIR"

git clone --depth 1 https://github.com/bats-core/bats-core "$BATS_DIR/bats"
rm -rf "$BATS_DIR/bats/.git"

git clone --depth 1 https://github.com/ztombol/bats-support "$BATS_DIR/bats-support"
rm -rf "$BATS_DIR/bats-support/.git"

git clone --depth 1 https://github.com/ztombol/bats-assert "$BATS_DIR/bats-assert"
rm -rf "$BATS_DIR/bats-assert/.git"

git clone --depth 1 https://github.com/jasonkarns/bats-mock.git "$BATS_DIR/bats-mock"
rm -rf "$BATS_DIR/bats-mock/.git"

echo "Bats libs installed to $BATS_DIR"
