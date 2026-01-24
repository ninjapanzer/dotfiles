#!/usr/bin/env bats

load '.test/bats/bats-support/load'
load '.test/bats/bats-assert/load'

SCRIPT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"

setup() {
    # Create temp directories
    TEST_TMP="$(mktemp -d)"
    export NIXOS_DIR="$TEST_TMP/etc-nixos"
    export BACKUP_DIR="$TEST_TMP/backup"
    export XDG_CONFIG_HOME="$TEST_TMP/config"

    mkdir -p "$NIXOS_DIR" "$BACKUP_DIR" "$XDG_CONFIG_HOME"

    # Create mock nixos files
    echo "# configuration.nix" > "$NIXOS_DIR/configuration.nix"
    echo "# flake.nix" > "$NIXOS_DIR/flake.nix"
    echo "# flake.lock" > "$NIXOS_DIR/flake.lock"

    # Create mock nixos-rebuild that logs calls
    export MOCK_LOG="$TEST_TMP/mock.log"
    export NIXOS_REBUILD="$TEST_TMP/mock-rebuild"
    cat > "$NIXOS_REBUILD" << 'EOF'
#!/usr/bin/env bash
echo "nixos-rebuild $*" >> "$MOCK_LOG"
exit 0
EOF
    chmod +x "$NIXOS_REBUILD"

    # Disable vcsh for most tests
    export PATH="$TEST_TMP/bin:$PATH"
    mkdir -p "$TEST_TMP/bin"
}

teardown() {
    rm -rf "$TEST_TMP"
}

@test "calls nixos-rebuild with switch by default" {
    run bash "$SCRIPT_DIR/os-build"
    assert_success
    assert [ -f "$MOCK_LOG" ]
    run cat "$MOCK_LOG"
    assert_output "nixos-rebuild switch --sudo"
}

@test "passes arguments to nixos-rebuild" {
    run bash "$SCRIPT_DIR/os-build" test
    assert_success
    run cat "$MOCK_LOG"
    assert_output "nixos-rebuild test --sudo"
}

@test "passes multiple arguments to nixos-rebuild" {
    run bash "$SCRIPT_DIR/os-build" switch --flake .
    assert_success
    run cat "$MOCK_LOG"
    assert_output "nixos-rebuild switch --flake . --sudo"
}

@test "copies config files to backup dir" {
    run bash "$SCRIPT_DIR/os-build"
    assert_success
    assert [ -f "$BACKUP_DIR/configuration.nix" ]
    assert [ -f "$BACKUP_DIR/flake.nix" ]
    assert [ -f "$BACKUP_DIR/flake.lock" ]
}

@test "--no-backup skips file copy" {
    run bash "$SCRIPT_DIR/os-build" --no-backup
    assert_success
    assert [ ! -f "$BACKUP_DIR/configuration.nix" ]
}

@test "--no-backup still runs nixos-rebuild" {
    run bash "$SCRIPT_DIR/os-build" --no-backup test
    assert_success
    run cat "$MOCK_LOG"
    assert_output "nixos-rebuild test --sudo"
}

@test "fails when nixos-rebuild fails" {
    # Create failing mock
    cat > "$NIXOS_REBUILD" << 'EOF'
#!/usr/bin/env bash
exit 1
EOF
    chmod +x "$NIXOS_REBUILD"

    run bash "$SCRIPT_DIR/os-build"
    assert_failure
    assert [ ! -f "$BACKUP_DIR/configuration.nix" ]
}

@test "only copies files that exist" {
    rm "$NIXOS_DIR/flake.lock"

    run bash "$SCRIPT_DIR/os-build"
    assert_success
    assert [ -f "$BACKUP_DIR/configuration.nix" ]
    assert [ -f "$BACKUP_DIR/flake.nix" ]
    assert [ ! -f "$BACKUP_DIR/flake.lock" ]
}

@test "creates backup dir if missing" {
    rmdir "$BACKUP_DIR"

    run bash "$SCRIPT_DIR/os-build"
    assert_success
    assert [ -d "$BACKUP_DIR" ]
}

@test "--help shows usage" {
    run bash "$SCRIPT_DIR/os-build" --help
    assert_success
    assert_output --partial "USAGE"
    assert_output --partial "--no-backup"
}

@test "-h shows usage" {
    run bash "$SCRIPT_DIR/os-build" -h
    assert_success
    assert_output --partial "USAGE"
}
