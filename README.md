# AI Agent Skills

A collection of custom skills, prompts, and configurations for AI coding assistants.

## Structure

The repo mirrors each tool's expected directory layout so you can symlink directly into your environment.

```
cursor/
  skills/
    refactor-analysis/SKILL.md   # → ~/.cursor/skills/refactor-analysis/SKILL.md
claude-code/                     # → ~/.claude/skills/
general/                         # Tool-agnostic prompts (adapt as needed)
```

## Installation

### Cursor

Symlink individual skills or the entire skills directory:

```bash
# All Cursor skills
ln -s /path/to/ai-agent-skills/cursor/skills/* ~/.cursor/skills/

# Single skill
ln -s /path/to/ai-agent-skills/cursor/skills/refactor-analysis ~/.cursor/skills/refactor-analysis
```

### Claude Code

```bash
# All Claude Code skills
ln -s /path/to/ai-agent-skills/claude-code/skills/* ~/.claude/skills/
```

## Available Skills

### Claude Code

| Skill | Description |
|-------|-------------|
| [code-review](claude-code/skills/code-review/SKILL.md) | Review code changes as an expert maintainer against project standards |
| [test-review](claude-code/skills/test-review/SKILL.md) | Review test code as a test expert and python packaging specialist |
| [doc-review](claude-code/skills/doc-review/SKILL.md) | Review documentation changes as a documentation and technical writing expert |
| [refactor-analysis](claude-code/skills/refactor-analysis/SKILL.md) | Analyze refactoring for structural regressions across 6 dimensions |

### Cursor

| Skill | Description |
|-------|-------------|
| [refactor-analysis](cursor/skills/refactor-analysis/SKILL.md) | Analyze refactoring for structural regressions across 6 dimensions |

## License

Apache License 2.0
