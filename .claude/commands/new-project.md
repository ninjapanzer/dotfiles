# New Project Setup

Bootstrap a new project with git, beads issue tracking, and Claude Code integration by calling the appropriate setup script.

## Two Modes

Parse `$ARGUMENTS` to determine the mode:

**Full Setup** — 3 arguments: `<project-name> <readme-path> <git-remote-url>`
**Minimal Setup** — 1 argument: `<project-name>`

If arguments are empty or ambiguous, ask the user which mode they want and what values to use.

## Execution

Run the appropriate script from `~/.claude/scripts/`:

**Full (3 args):**
```bash
~/.claude/scripts/project-setup-full.sh <project-name> <readme-path> <git-remote-url>
```

**Minimal (1 arg):**
```bash
~/.claude/scripts/project-setup-minimal.sh <project-name>
```

Show the user the full output. If any steps show `[FAIL]`, explain what failed and suggest how to fix it.

## Arguments

$ARGUMENTS
