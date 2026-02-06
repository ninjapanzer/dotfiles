# Beads Orchestration Loop

Run the automated beads development loop that processes issues using git worktrees with Sonnet implementers and Haiku reviewers running as **separate CLI subprocesses**.

## Architecture

Workers run as isolated `claude --dangerously-skip-permissions` processes, NOT as Task tool subagents. This prevents memory exhaustion in the orchestrator.

## Usage

```
/beads-orchestrate [options]
```

## Options (parsed from $ARGUMENTS)

- `--max=N` or just a number: Maximum parallel issues to process (default: 2, max: 3)
- `--once`: Run one batch only, don't loop until empty
- `--dry-run`: Show what would be processed without executing
- `--batches=N`: Maximum batches before stopping (default: 10)

## Examples

```
/beads-orchestrate           # Process up to 2 issues/batch, max 10 batches
/beads-orchestrate --once    # Process one batch then stop
/beads-orchestrate --dry-run # Show ready issues without processing
/beads-orchestrate --max=3   # Process up to 3 issues in parallel
```

## Execution

**You (the current session) ARE the orchestrator.** Read and follow the instructions in `~/.claude/agents/beads-orchestrator.md` directly.

Key points:
1. Read the agent file to understand your role
2. Workers are launched via `claude --dangerously-skip-permissions --model sonnet|haiku --print -p "..."`
3. Workers run in their worktree directory
4. You handle merges, status updates, and cleanup

## Pre-flight Checks

Before starting, verify:
1. Current directory is a git repo with `.beads/`
2. Working tree is clean (`git status` shows no uncommitted changes)
3. On master/main branch
4. `bd ready` returns at least one non-epic issue

If any check fails, report the issue and ask how to proceed.

## Arguments

$ARGUMENTS
