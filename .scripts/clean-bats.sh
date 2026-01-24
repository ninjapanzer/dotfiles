#!/bin/bash -e

if [ -d "./.test/bats" ]; then
    rm -rf "./.test/bats/"
    echo "Cleaned .test/bats"
fi
