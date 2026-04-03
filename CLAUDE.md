# Claude Code Guide for ai-agent-skills

> **Read [AGENTS.md](AGENTS.md) first** — it contains the project overview, structure, conventions, and commit message format.

## Claude Code-Specific Notes

- Skills live in `claude-code/skills/<name>/SKILL.md` and map to `~/.claude/skills/<name>/SKILL.md`
- Users install via symlink: `ln -s /path/to/repo/claude-code/skills/* ~/.claude/skills/`

## Commit Messages

Keep commit messages concise and easy to understand. Follow the conventions in [AGENTS.md](AGENTS.md#commit-messages).

## Before Considering Done

- [ ] Skill has valid frontmatter (`name`, `description`, `user-invocable`)
- [ ] README.md "Available Skills" table is updated
- [ ] No project-specific hardcoded paths in shared skills
