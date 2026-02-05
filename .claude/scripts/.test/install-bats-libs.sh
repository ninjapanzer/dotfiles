#!/usr/bin/env bash
set -e

if [ -d "./.test/bats" ]; then
  echo "Deleting existing bats folder"
  rm -rf "./.test/bats/"
  mkdir -p ./.test/bats
else
  mkdir -p ./.test/bats
fi

git clone --depth 1 https://github.com/bats-core/bats-core ./.test/bats/bats
rm -rf ./.test/bats/bats/.git

git clone --depth 1 https://github.com/ztombol/bats-support ./.test/bats/bats-support
rm -rf ./.test/bats/bats-support/.git

git clone --depth 1 https://github.com/ztombol/bats-assert ./.test/bats/bats-assert
rm -rf ./.test/bats/bats-assert/.git

git clone --depth 1 https://github.com/jasonkarns/bats-mock.git ./.test/bats/bats-mock
rm -rf ./.test/bats/bats-mock/.git
