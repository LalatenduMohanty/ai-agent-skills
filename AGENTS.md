# AI Agent Guide for ai-agent-skills

> This file follows the [AGENTS.md](https://agents.md/) open standard.

## Project Overview

A collection of reusable skills for AI coding assistants (Claude Code, Cursor, Copilot, etc.). The repo mirrors each tool's expected directory layout so skills can be symlinked directly into a user's environment.

## Repository Structure

```
claude-code/skills/<name>/SKILL.md   # Claude Code skills (→ ~/.claude/skills/)
cursor/skills/<name>/SKILL.md        # Cursor skills (→ ~/.cursor/skills/)
general/                             # Tool-agnostic prompts
```

## Conventions

### Skill File Format

Every skill lives in `<tool>/skills/<skill-name>/SKILL.md` and must include YAML frontmatter:

```yaml
---
name: skill-name
description: When and why this skill should be triggered
user-invocable: true
---
```

### Key Rules

- **Portability**: Skills should be tool-agnostic where possible. Avoid hardcoding project-specific paths, tools, or configurations.
- **Consistent output**: Use the Severity / Location / Issue / Suggestion format for review-type skills.
- **README sync**: Always update the "Available Skills" table in `README.md` when adding or removing skills.
- **No duplication**: Only add a skill to multiple tool directories if the format genuinely differs between tools.

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Keep messages concise and easy to understand — a reader should grasp the change without opening the diff.

```
feat(<tool>): add <skill-name> skill
fix(<tool>): <what was fixed>
docs: update README
```

## Permissions

### Safe to Do

- Read any file
- Add new skills following the directory conventions
- Edit existing skills to improve clarity or fix issues
- Update README.md

### Ask First

- Removing or renaming existing skills
- Changing the directory structure
- Modifying LICENSE
