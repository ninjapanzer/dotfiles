#!/usr/bin/env bash
set -e

if [ -d "./.test/bats" ]; then
  echo "Deleting bats folder"
  rm -rf "./.test/bats/"
fi
