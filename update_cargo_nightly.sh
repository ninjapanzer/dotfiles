#!/bin/bash
set -e

cargo_url="https://static.rust-lang.org/cargo-dist/cargo-nightly-x86_64-apple-darwin.tar.gz"

cargo_install_dir="$(brew --cellar)/cargo/HEAD"
cargo_new_dir="${cargo_install_dir}.new"
cargo_old_dir="${cargo_install_dir}.old"

[[ -d "$cargo_new_dir" ]] && rm -rf "$cargo_new_dir"
mkdir -p "$cargo_new_dir"
curl "$cargo_url" | tar -C "$cargo_new_dir" --strip-components 1 -zxf -

brew unlink cargo
[[ -d "$cargo_old_dir" ]] && rm -rf "$cargo_old_dir"
[[ -d "$cargo_install_dir" ]] && mv "$cargo_install_dir" "$cargo_old_dir"
mv "$cargo_new_dir" "$cargo_install_dir"
brew link cargo
