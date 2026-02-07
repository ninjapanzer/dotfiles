#!/usr/bin/env bash
set -euo pipefail

# project-setup-minimal.sh
# Minimal project scaffolding: directory + empty README + beads structure,
# then initializes git and beads automatically.
#
# Usage:
#   project-setup-minimal.sh <project-name>
#
# Example:
#   project-setup-minimal.sh my-cool-app

CHECKLIST=()
FAILED=()

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
  echo "Usage: $0 <project-name>"
  echo ""
  echo "  project-name    Directory name for the new project"
  echo ""
  echo "Creates a project skeleton with git and beads initialized."
  exit 1
}

# ── Validate args ────────────────────────────────────────────────────────────

[[ $# -lt 1 ]] && usage

PROJECT_NAME="$1"
PROJECT_DIR="${PROJECTS_ROOT:-$(pwd)}/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
  echo "Error: Directory already exists: $PROJECT_DIR"
  exit 1
fi

echo "══════════════════════════════════════════════════════════════"
echo "  Project Setup (Minimal)  →  $PROJECT_NAME"
echo "══════════════════════════════════════════════════════════════"

# ── Step 1: Create project directory ─────────────────────────────────────────

step "Create project directory" mkdir -p "$PROJECT_DIR"

# ── Step 2: Create empty README.md ──────────────────────────────────────────

step "Create empty README.md" bash -c 'echo "# '"$PROJECT_NAME"'" > "'"$PROJECT_DIR"'/README.md"'

# ── Step 3: Create .beads directory placeholder ─────────────────────────────
# This gives the directory structure a hint that beads will be used.
# bd init will overwrite this with a real database when you run it.

step "Create .beads/ placeholder directory" mkdir -p "$PROJECT_DIR/.beads"

step "Create .beads/.gitkeep" touch "$PROJECT_DIR/.beads/.gitkeep"

# ── Step 4: Create stub CLAUDE.md ────────────────────────────────────────────

step "Create stub CLAUDE.md" bash -c 'cat > "'"$PROJECT_DIR"'/CLAUDE.md" << '\''STUB'\''
# CLAUDE.md

## Project Overview

<!-- Describe this project here -->

## Build & Development Commands

<!-- Add commands here after project init -->

## Architecture

<!-- Describe architecture here -->
STUB'

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
  echo "  All steps passed. Skeleton ready at: $PROJECT_DIR"
fi

# ── Next steps: git + beads init ─────────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Initializing Git & Beads"
echo "══════════════════════════════════════════════════════════════"

cd "$PROJECT_DIR"

step "git init" git init
step "Stage all files" git add -A
step "Initial commit" git commit -m "Initial commit"
step "bd init" bd init
step "bd setup claude" bd setup claude
step "bd hooks install" bd hooks install
step "bd migrate --yes" bd migrate --yes
step "bd migrate sync beads-sync" bd migrate sync beads-sync
step "bd sync" bd sync

# ── Commit beads files ───────────────────────────────────────────────────────

step "Stage beads files" git add -A
step "Commit beads setup" git commit -m "Add beads issue tracking"

step "bd doctor" bd doctor

# ── Final Summary ────────────────────────────────────────────────────────────

echo ""
echo "══════════════════════════════════════════════════════════════"
echo "  Final Checklist"
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
  echo "  ✓ Project fully initialized at: $PROJECT_DIR"
fi
