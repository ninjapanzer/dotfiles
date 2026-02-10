# New Project Setup

Bootstrap a new project with git, beads issue tracking, and Claude Code integration.

## Two Modes

Parse `$ARGUMENTS` to determine the mode:

**Full Setup** — 3 arguments: `<project-name> <readme-path> <git-remote-url>`
**Minimal Setup** — 1 argument: `<project-name>`

If arguments are empty or ambiguous, ask the user which mode they want and what values to use.

## Task Order (IMPORTANT)

For **Full Setup**, you MUST complete these phases in strict order:

### Phase 1: Read and Understand the User's Brief

**Before running any scripts**, read the readme-path file provided by the user. This is the source of truth for what the project should be. Internalize:
- What the project is about
- Technology stack preferences
- Architecture or structure hints
- Goals and features

Store this understanding—you will need it for Phase 3.

### Phase 2: Run the Setup Script

Run the setup script:
```bash
~/.claude/scripts/project-setup-full.sh <project-name> <readme-path> <git-remote-url>
```

Show the user the full output. If any steps show `[FAIL]`, explain what failed and suggest how to fix it.

**Do NOT read any files in the new project directory after this step.** The script creates a template README.md that will confuse you. Your understanding from Phase 1 is what matters.

### Phase 3: Rewrite README.md from Your Understanding

Using ONLY your understanding from Phase 1 (not by reading files), rewrite the project's README.md:
- Transform the user's brief into a well-structured project README
- Use the template structure (Project Overview, Goals, Proposed Features, Technical Considerations, Open Questions)
- Keep the reference to ORIGINAL_BRIEF.md at the bottom

Then commit and push:
```bash
git add README.md && git commit -m "Transform brief into structured README" && git push
```

### Phase 4: Exit

Report success to the user. Tell them:
- The project is ready at the new directory path
- They should `cd` into it and run `claude` to continue

**Do NOT scaffold, do NOT read additional files, do NOT continue with other tasks.** The project is ready for the user to take over.

---

## Minimal Setup (1 arg)

Just run the script and report results:
```bash
~/.claude/scripts/project-setup-minimal.sh <project-name>
```

## Arguments

$ARGUMENTS
