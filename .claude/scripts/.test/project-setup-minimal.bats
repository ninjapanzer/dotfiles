#!/usr/bin/env bats
# Tests for project-setup-minimal.sh

TESTS_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
SCRIPTS_DIR="$(cd "$TESTS_DIR/.." && pwd)"
SCRIPT="$SCRIPTS_DIR/project-setup-minimal.sh"

load test_helper

setup() {
  setup_tmpdir
  setup_mocks
}

teardown() {
  teardown_tmpdir
}

# ── Argument validation ─────────────────────────────────────────────────────

@test "exits with usage when no arguments given" {
  run bash "$SCRIPT"
  assert_failure
  assert_output --partial "Usage:"
}

@test "exits with error when directory already exists" {
  mkdir -p "$TEST_TMPDIR/existing-project"
  run bash "$SCRIPT" "existing-project"
  assert_failure
  assert_output --partial "Directory already exists"
}

# ── Scaffolding phase ───────────────────────────────────────────────────────

@test "creates project directory" {
  run bash "$SCRIPT" "test-project"
  assert_success
  [ -d "$TEST_TMPDIR/test-project" ]
}

@test "creates README.md with project name as heading" {
  run bash "$SCRIPT" "test-project"
  assert_success
  [ -f "$TEST_TMPDIR/test-project/README.md" ]
  grep -q "# test-project" "$TEST_TMPDIR/test-project/README.md"
}

@test "creates .beads/ placeholder directory" {
  run bash "$SCRIPT" "test-project"
  assert_success
  [ -d "$TEST_TMPDIR/test-project/.beads" ]
}

@test "creates .beads/.gitkeep" {
  run bash "$SCRIPT" "test-project"
  assert_success
  [ -f "$TEST_TMPDIR/test-project/.beads/.gitkeep" ]
}

@test "creates CLAUDE.md with stub content" {
  run bash "$SCRIPT" "test-project"
  assert_success
  [ -f "$TEST_TMPDIR/test-project/CLAUDE.md" ]
  grep -q "# CLAUDE.md" "$TEST_TMPDIR/test-project/CLAUDE.md"
  grep -q "## Project Overview" "$TEST_TMPDIR/test-project/CLAUDE.md"
  grep -q "## Build & Development Commands" "$TEST_TMPDIR/test-project/CLAUDE.md"
  grep -q "## Architecture" "$TEST_TMPDIR/test-project/CLAUDE.md"
}

# ── Git & Beads phase ───────────────────────────────────────────────────────

@test "runs git init" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "git init"
}

@test "stages all files and creates initial commit" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "git add -A"
  assert_mock_called "git commit -m Initial commit"
}

@test "runs bd init" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd init"
}

@test "runs bd setup claude" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd setup claude"
}

@test "runs bd hooks install" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd hooks install"
}

@test "runs bd migrate --yes" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd migrate --yes"
}

@test "runs bd migrate sync beads-sync" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd migrate sync beads-sync"
}

@test "runs bd sync" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd sync"
}

@test "commits beads setup files" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "git commit -m Add beads issue tracking"
}

@test "runs bd doctor" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_mock_called "bd doctor"
}

# ── Execution order ─────────────────────────────────────────────────────────

@test "git init happens before bd init" {
  run bash "$SCRIPT" "test-project"
  assert_success
  local git_init_line bd_init_line
  git_init_line=$(grep -n "git init" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  bd_init_line=$(grep -n "bd init" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$git_init_line" -lt "$bd_init_line" ]
}

@test "bd migrate sync happens after bd migrate --yes" {
  run bash "$SCRIPT" "test-project"
  assert_success
  local migrate_line sync_branch_line
  migrate_line=$(grep -n "bd migrate --yes" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  sync_branch_line=$(grep -n "bd migrate sync beads-sync" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$migrate_line" -lt "$sync_branch_line" ]
}

@test "bd migrate sync happens before bd sync" {
  run bash "$SCRIPT" "test-project"
  assert_success
  local sync_branch_line sync_line
  sync_branch_line=$(grep -n "bd migrate sync beads-sync" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  sync_line=$(grep -n "bd sync$" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$sync_branch_line" -lt "$sync_line" ]
}

@test "bd sync happens before beads commit" {
  run bash "$SCRIPT" "test-project"
  assert_success
  local sync_line commit_line
  sync_line=$(grep -n "bd sync$" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  commit_line=$(grep -n "git commit -m Add beads" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$sync_line" -lt "$commit_line" ]
}

@test "bd doctor runs after beads commit" {
  run bash "$SCRIPT" "test-project"
  assert_success
  local commit_line doctor_line
  commit_line=$(grep -n "git commit -m Add beads" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  doctor_line=$(grep -n "bd doctor" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$commit_line" -lt "$doctor_line" ]
}

# ── Output ──────────────────────────────────────────────────────────────────

@test "output includes project name in header" {
  run bash "$SCRIPT" "my-app"
  assert_success
  assert_output --partial "my-app"
}

@test "output includes skeleton checklist" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_output --partial "Setup Checklist"
}

@test "output includes git & beads section header" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_output --partial "Initializing Git & Beads"
}

@test "output includes final checklist" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_output --partial "Final Checklist"
}

@test "output reports fully initialized on success" {
  run bash "$SCRIPT" "test-project"
  assert_success
  assert_output --partial "Project fully initialized at"
}

# ── PROJECTS_ROOT override ──────────────────────────────────────────────────

@test "respects PROJECTS_ROOT environment variable" {
  local custom_root="$TEST_TMPDIR/custom"
  mkdir -p "$custom_root"
  PROJECTS_ROOT="$custom_root" run bash "$SCRIPT" "test-project"
  assert_success
  [ -d "$custom_root/test-project" ]
}
