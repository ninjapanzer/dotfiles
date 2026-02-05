#!/usr/bin/env bats
# Tests for project-setup-full.sh

TESTS_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
SCRIPTS_DIR="$(cd "$TESTS_DIR/.." && pwd)"
SCRIPT="$SCRIPTS_DIR/project-setup-full.sh"

load test_helper

setup() {
  setup_tmpdir
  setup_mocks
  # Create a seed README for the full setup script
  SEED_README="$TEST_TMPDIR/seed-readme.md"
  echo "# My Project" > "$SEED_README"
  echo "This is the project brief." >> "$SEED_README"
  export SEED_README
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

@test "exits with usage when only 1 argument given" {
  run bash "$SCRIPT" "test-project"
  assert_failure
  assert_output --partial "Usage:"
}

@test "exits with usage when only 2 arguments given" {
  run bash "$SCRIPT" "test-project" "$SEED_README"
  assert_failure
  assert_output --partial "Usage:"
}

@test "exits with error when README file does not exist" {
  run bash "$SCRIPT" "test-project" "/nonexistent/readme.md" "git@github.com:user/repo.git"
  assert_failure
  assert_output --partial "README file not found"
}

@test "exits with error when directory already exists" {
  mkdir -p "$TEST_TMPDIR/existing-project"
  run bash "$SCRIPT" "existing-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_failure
  assert_output --partial "Directory already exists"
}

# ── Scaffolding ─────────────────────────────────────────────────────────────

@test "creates project directory" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  [ -d "$TEST_TMPDIR/test-project" ]
}

@test "copies seed README into project" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  [ -f "$TEST_TMPDIR/test-project/README.md" ]
  grep -q "# My Project" "$TEST_TMPDIR/test-project/README.md"
  grep -q "This is the project brief." "$TEST_TMPDIR/test-project/README.md"
}

@test "creates CLAUDE.md" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  [ -f "$TEST_TMPDIR/test-project/CLAUDE.md" ]
  grep -q "# CLAUDE.md" "$TEST_TMPDIR/test-project/CLAUDE.md"
}

# ── Git operations ──────────────────────────────────────────────────────────

@test "initializes git repository" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git init"
}

@test "stages and commits README" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git add README.md"
  assert_mock_called "git commit -m Initial commit: seed README"
}

@test "adds git remote origin" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git remote add origin git@github.com:user/repo.git"
}

@test "pushes initial commit to remote" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git push -u origin main"
}

@test "commits beads setup artifacts" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git add -A"
  assert_mock_called "git commit -m Setup: initialize beads, Claude integration, git hooks"
}

@test "pushes beads setup to remote" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "git push"
}

# ── Beads operations ────────────────────────────────────────────────────────

@test "runs bd init" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd init"
}

@test "runs bd setup claude" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd setup claude"
}

@test "runs bd hooks install" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd hooks install"
}

@test "runs bd doctor" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd doctor"
}

@test "runs bd migrate --yes" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd migrate --yes"
}

@test "runs bd sync" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd sync"
}

@test "runs bd onboard for CLAUDE.md content" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_mock_called "bd onboard"
}

# ── Execution order ─────────────────────────────────────────────────────────

@test "git init happens before adding remote" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  local init_line remote_line
  init_line=$(grep -n "git init" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  remote_line=$(grep -n "git remote add" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$init_line" -lt "$remote_line" ]
}

@test "bd init happens after git init" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  local git_init_line bd_init_line
  git_init_line=$(grep -n "git init" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  bd_init_line=$(grep -n "bd init" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$git_init_line" -lt "$bd_init_line" ]
}

@test "bd doctor happens before bd migrate" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  local doctor_line migrate_line
  doctor_line=$(grep -n "bd doctor" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  migrate_line=$(grep -n "bd migrate" "$MOCK_CALL_LOG" | head -1 | cut -d: -f1)
  [ "$doctor_line" -lt "$migrate_line" ]
}

# ── Output ──────────────────────────────────────────────────────────────────

@test "output includes project name in header" {
  run bash "$SCRIPT" "my-app" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_output --partial "my-app"
}

@test "output includes remote URL in header" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_output --partial "git@github.com:user/repo.git"
}

@test "output includes setup checklist" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_output --partial "Setup Checklist"
}

@test "output reports project ready on success" {
  run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  assert_output --partial "Project ready at"
}

# ── PROJECTS_ROOT override ──────────────────────────────────────────────────

@test "respects PROJECTS_ROOT environment variable" {
  local custom_root="$TEST_TMPDIR/custom"
  mkdir -p "$custom_root"
  PROJECTS_ROOT="$custom_root" run bash "$SCRIPT" "test-project" "$SEED_README" "git@github.com:user/repo.git"
  assert_success
  [ -d "$custom_root/test-project" ]
}
