# AI Agent Guide for ai-agent-skills

> This file follows the [AGENTS.md](https://agents.md/) open standard.

## Project Overview

A plugin marketplace of reusable skills for AI coding assistants. Claude Code skills are distributed as a plugin marketplace; Cursor skills use symlink installation.

## Repository Structure

```
.claude-plugin/marketplace.json              # Plugin marketplace catalog
plugins/<name>/                              # Claude Code plugins
  .claude-plugin/plugin.json                 # Plugin manifest (name, description, version)
  skills/<name>/SKILL.md                     # Plugin skill
cursor/skills/<name>/SKILL.md               # Cursor skills (symlink install)
general/                                     # Tool-agnostic prompts
```

## Conventions

### Plugin Structure

Each Claude Code plugin lives in `plugins/<plugin-name>/` and must contain:

1. **`.claude-plugin/plugin.json`** — plugin manifest:
   ```json
   {
     "name": "plugin-name",
     "description": "What this plugin does",
     "version": "1.0.0"
   }
   ```

2. **`skills/<skill-name>/SKILL.md`** — skill file with YAML frontmatter:
   ```yaml
   ---
   name: skill-name
   description: When and why this skill should be triggered
   user-invocable: true
   ---
   ```

3. A corresponding entry in `.claude-plugin/marketplace.json`.

### Cursor Skill Format

Cursor skills live in `cursor/skills/<skill-name>/SKILL.md` with the same YAML frontmatter format.

### Key Rules

- **Portability**: Skills should be tool-agnostic where possible. Avoid hardcoding project-specific paths, tools, or configurations.
- **Consistent output**: Use the Severity / Location / Issue / Suggestion format for review-type skills.
- **README sync**: Always update the "Available Skills" table in `README.md` when adding or removing skills.
- **Marketplace sync**: When adding a Claude Code plugin, add an entry in `.claude-plugin/marketplace.json`.
- **No duplication**: Only add a skill to multiple tool directories if the format genuinely differs between tools.
- **Versioning**: Plugin versions are managed in `plugin.json`, not in SKILL.md frontmatter.

### Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Keep messages concise and easy to understand — a reader should grasp the change without opening the diff.

```
feat(plugin): add <plugin-name> plugin
fix(plugin): <what was fixed>
docs: update README
```

## Permissions

### Safe to Do

- Read any file
- Add new plugins following the directory conventions
- Edit existing skills to improve clarity or fix issues
- Update README.md

### Ask First

- Removing or renaming existing plugins
- Changing the directory structure
- Modifying LICENSE
