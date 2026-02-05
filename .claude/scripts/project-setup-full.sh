#!/usr/bin/env bash
set -euo pipefail

# project-setup-full.sh
# Full project setup: git + beads + Claude integration + remote push
#
# Usage:
#   project-setup-full.sh <project-name> <readme-path> <git-remote-url>
#
# Example:
#   project-setup-full.sh my-cool-app ./brief.md git@github.com:ninjapanzer/my-cool-app.git

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECKLIST=()
FAILED=()

# ── Helpers ──────────────────────────────────────────────────────────────────

step() {
  local label="$1"
  shift
  printf "\n  [..] %s" "$label"
  if "$@" > /tmp/ps-step-out.log 2>&1; then
    printf "\r  [OK] %s\n" "$label"
    CHECKLIST+=("[OK] $label")
    return 0
  else
    printf "\r  [FAIL] %s\n" "$label"
    CHECKLIST+=("[FAIL] $label")
    FAILED+=("$label")
    echo "       ↳ $(tail -1 /tmp/ps-step-out.log)"
    return 1
  fi
}

usage() {
  echo "Usage: $0 <project-name> <readme-path> <git-remote-url>"
  echo ""
  echo "  project-name    Directory name for the new project"
  echo "  readme-path     Path to a README/brief to seed README.md"
  echo "  git-remote-url  Git remote URL (SSH or HTTPS)"
  exit 1
}

# ── Validate args ────────────────────────────────────────────────────────────

[[ $# -lt 3 ]] && usage

PROJECT_NAME="$1"
README_PATH="$2"
GIT_REMOTE="$3"
PROJECT_DIR="${PROJECTS_ROOT:-$(pwd)}/$PROJECT_NAME"

if [[ ! -f "$README_PATH" ]]; then
  echo "Error: README file not found: $README_PATH"
  exit 1
fi

if [[ -d "$PROJECT_DIR" ]]; then
  echo "Error: Directory already exists: $PROJECT_DIR"
  exit 1
fi

echo "══════════════════════════════════════════════════════════════"
echo "  Project Setup (Full)  →  $PROJECT_NAME"
echo "  Remote: $GIT_REMOTE"
echo "══════════════════════════════════════════════════════════════"

# ── Step 1: Create project directory ─────────────────────────────────────────

step "Create project directory" mkdir -p "$PROJECT_DIR" || true
cd "$PROJECT_DIR"

# ── Step 2: Initialize git ──────────────────────────────────────────────────

step "Initialize git repository" git init || true

# ── Step 3: Seed README.md ──────────────────────────────────────────────────

step "Copy README.md from brief" cp "$README_PATH" "$PROJECT_DIR/README.md" || true

# ── Step 4: Initial commit ──────────────────────────────────────────────────

step "Stage and commit README" bash -c 'cd "'"$PROJECT_DIR"'" && git add README.md && git commit -m "Initial commit: seed README"' || true

# ── Step 5: Add remote and push ─────────────────────────────────────────────

step "Add git remote origin" git remote add origin "$GIT_REMOTE" || true

step "Push initial commit to remote" bash -c 'cd "'"$PROJECT_DIR"'" && git push -u origin "$(git branch --show-current)"' || true

# ── Step 6: Initialize beads ────────────────────────────────────────────────

step "Initialize beads (bd init)" bd init || true

# ── Step 7: Setup Claude integration ────────────────────────────────────────

step "Setup Claude integration (bd setup claude)" bd setup claude || true

# ── Step 8: Install git hooks ───────────────────────────────────────────────

step "Install beads git hooks" bd hooks install || true

# ── Step 9: Run bd doctor (read-only) ────────────────────────────────────────
# Doctor reports health status only. We never run --fix as it can upgrade the
# beads version. Migrate and sync are handled explicitly below.

step "Run bd doctor (read-only)" bd doctor || true

# ── Step 9a: Migrate database schema ────────────────────────────────────────

step "Run bd migrate" bd migrate --yes || true

# ── Step 9b: Sync database to JSONL ─────────────────────────────────────────

step "Run bd sync" bd sync || true

# ── Step 10: Seed CLAUDE.md with onboard snippet ────────────────────────────

step "Create CLAUDE.md with bd onboard" bash -c 'cd "'"$PROJECT_DIR"'" && echo "# CLAUDE.md" > CLAUDE.md && echo "" >> CLAUDE.md && bd onboard >> CLAUDE.md' || true

# ── Step 11: Commit beads artifacts ─────────────────────────────────────────

step "Commit beads setup artifacts" bash -c 'cd "'"$PROJECT_DIR"'" && git add -A && git commit -m "Setup: initialize beads, Claude integration, git hooks"' || true

# ── Step 12: Push beads setup ───────────────────────────────────────────────

step "Push beads setup to remote" bash -c 'cd "'"$PROJECT_DIR"'" && git push' || true

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Setup Checklist"
echo "══════════════════════════════════════════════════════════════"
for item in "${CHECKLIST[@]}"; do
  echo "  $item"
done

if [[ ${#FAILED[@]} -gt 0 ]]; then
  echo ""
  echo "  ⚠ ${#FAILED[@]} step(s) failed. Review output above."
  exit 1
else
  echo ""
  echo "  All steps passed. Project ready at: $PROJECT_DIR"
  echo "  Run: cd $PROJECT_DIR && claude"
fi
