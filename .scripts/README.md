# Scripts

Personal utility scripts.

## os-build

NixOS rebuild wrapper with automatic vcsh backup.

```bash
os-build              # nixos-rebuild switch + backup to vcsh
os-build --no-backup  # rebuild without backup
os-build test         # nixos-rebuild test + backup
os-build boot --flake .  # pass any args to nixos-rebuild
```

Alias defined in `~/.alias/scripts.alias`.

Copies `/etc/nixos/*.nix` to `~/.nixos/` and commits to `vcsh nixos` repo with version info.

### Config

Optional `~/.config/nixos-backup/config.yaml`:

```yaml
files:
  - configuration.nix
  - flake.nix
  - flake.lock
  - hardware-configuration.nix
  - home.nix
  - packages.nix
vcsh_repo: nixos
backup_dir: .nixos
```

Without config (or without `yq`), uses hardcoded defaults.

### Dependencies

- `vcsh` - for git repo management
- `yq` (optional) - for yaml config parsing

## Testing with Bats

Uses [bats-core](https://github.com/bats-core/bats-core) for bash testing.

### Setup

```bash
bash install-bats-libs.sh
```

Installs to `.test/bats/`:
- bats-core
- bats-support
- bats-assert
- bats-mock

### Running tests

```bash
make test          # run all *.bats tests
make test-setup    # install bats libs if missing
make test-clean    # remove bats libs
```

Or directly:

```bash
./.test/bats/bats/bin/bats *.bats
```

### Writing tests

Tests go in `<script>.bats` alongside the script. Example structure:

```bash
#!/usr/bin/env bats

load '.test/bats/bats-support/load'
load '.test/bats/bats-assert/load'

setup() {
    # runs before each test
}

teardown() {
    # runs after each test
}

@test "description of test" {
    run bash my-script
    assert_success
    assert_output "expected output"
}
```

### Cleanup

```bash
bash clean-bats.sh
```
