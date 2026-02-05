#!/usr/bin/env bash
# test_helper.bash — shared setup for all BATS tests
#
# Provides:
#   - bats-support + bats-assert loading
#   - MOCK_BIN directory with stub git/bd on PATH
#   - TEST_TMPDIR for throwaway project directories
#   - Helpers: call log inspection, cleanup

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$(cd "$TESTS_DIR/.." && pwd)"

# ── Load BATS libraries ────────────────────────────────────────────────────

load "${TESTS_DIR}/bats/bats-support/load"
load "${TESTS_DIR}/bats/bats-assert/load"

# ── Per-test temp directory ─────────────────────────────────────────────────

setup_tmpdir() {
  TEST_TMPDIR="$(mktemp -d)"
  export TEST_TMPDIR
  export PROJECTS_ROOT="$TEST_TMPDIR"
  # Log file where mock commands record their invocations
  export MOCK_CALL_LOG="$TEST_TMPDIR/mock_calls.log"
  touch "$MOCK_CALL_LOG"
}

teardown_tmpdir() {
  if [[ -n "${TEST_TMPDIR:-}" && -d "$TEST_TMPDIR" ]]; then
    rm -rf "$TEST_TMPDIR"
  fi
}

# ── Mock binaries ───────────────────────────────────────────────────────────
# Creates a MOCK_BIN directory with stub scripts for git and bd.
# Each stub logs calls to MOCK_CALL_LOG and returns 0.

setup_mocks() {
  MOCK_BIN="$TEST_TMPDIR/mock_bin"
  mkdir -p "$MOCK_BIN"

  # Mock git
  cat > "$MOCK_BIN/git" << 'MOCKGIT'
#!/usr/bin/env bash
echo "git $*" >> "$MOCK_CALL_LOG"

# git branch --show-current → return "main"
if [[ "${1:-}" == "branch" && "${2:-}" == "--show-current" ]]; then
  echo "main"
  exit 0
fi

exit 0
MOCKGIT
  chmod +x "$MOCK_BIN/git"

  # Mock bd
  cat > "$MOCK_BIN/bd" << 'MOCKBD'
#!/usr/bin/env bash
echo "bd $*" >> "$MOCK_CALL_LOG"

# bd onboard → emit a stub snippet
if [[ "${1:-}" == "onboard" ]]; then
  echo "## Issue Tracking"
  echo ""
  echo "This project uses beads for issue tracking."
  exit 0
fi

exit 0
MOCKBD
  chmod +x "$MOCK_BIN/bd"

  # Mock touch (some systems need it, but usually built-in — keep real)
  # We only prepend MOCK_BIN for git and bd; keep everything else real.
  export PATH="$MOCK_BIN:$PATH"
}

# ── Assertion helpers ───────────────────────────────────────────────────────

# assert_mock_called <command-pattern>
#   Checks that MOCK_CALL_LOG contains a line matching the pattern.
assert_mock_called() {
  local pattern="$1"
  grep -q "$pattern" "$MOCK_CALL_LOG" || {
    echo "Expected mock call matching: $pattern"
    echo "Actual calls:"
    cat "$MOCK_CALL_LOG"
    return 1
  }
}

# refute_mock_called <command-pattern>
#   Checks that MOCK_CALL_LOG does NOT contain a line matching the pattern.
refute_mock_called() {
  local pattern="$1"
  if grep -q "$pattern" "$MOCK_CALL_LOG"; then
    echo "Unexpected mock call matching: $pattern"
    echo "Actual calls:"
    cat "$MOCK_CALL_LOG"
    return 1
  fi
}

# mock_call_count <command-pattern>
#   Outputs the number of matching lines.
mock_call_count() {
  local pattern="$1"
  grep -c "$pattern" "$MOCK_CALL_LOG" || echo "0"
}
