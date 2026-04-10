# Claude Code Guide for ai-agent-skills

> **Read [AGENTS.md](AGENTS.md) first** — it contains the project overview, structure, conventions, and commit message format.

## Claude Code-Specific Notes

- This repo is a Claude Code **plugin marketplace**
- Plugins live in `plugins/<name>/` with a `.claude-plugin/plugin.json` manifest
- Skills live in `plugins/<name>/skills/<skill-name>/SKILL.md`
- The marketplace catalog is `.claude-plugin/marketplace.json`
- Users install via: `/plugin marketplace add LalatenduMohanty/ai-agent-skills`

## Commit Messages

Keep commit messages concise and easy to understand. Follow the conventions in [AGENTS.md](AGENTS.md#commit-messages).

## Before Considering Done

- [ ] Skill has valid frontmatter (`name`, `description`, `user-invocable`)
- [ ] Plugin has valid `.claude-plugin/plugin.json` (`name`, `description`, `version`)
- [ ] Plugin is listed in `.claude-plugin/marketplace.json`
- [ ] README.md "Available Plugins" table is updated
- [ ] No project-specific hardcoded paths in shared skills
