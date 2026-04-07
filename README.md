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

## Development

The skills tables in this README are auto-generated from `SKILL.md` frontmatter. To update them after adding or modifying a skill:

```bash
./scripts/update-readme-skills.sh
```

To enable the pre-commit hook that checks tables are up to date:

```bash
git config core.hooksPath .githooks
```

## Available Skills

### Claude Code

<!-- BEGIN CLAUDE-CODE SKILLS -->
| Skill | Description |
|-------|-------------|
| [code-review](claude-code/skills/code-review/SKILL.md) | Review code changes as an expert maintainer against project standards |
| [doc-review](claude-code/skills/doc-review/SKILL.md) | Review documentation changes as a documentation and technical writing expert |
| [pr-reading-order](claude-code/skills/pr-reading-order/SKILL.md) | Suggest the best reading order to understand and review a PR's code changes |
| [refactor-analysis](claude-code/skills/refactor-analysis/SKILL.md) | This skill should be used when the user asks to "analyze a refactoring", "check for structural regressions", "review refactoring PR", "check refactor quality", or needs analysis of DRY violations, abstraction bypasses, behavioral changes, API compatibility, cache safety, or clean code issues in refactored code. |
| [test-review](claude-code/skills/test-review/SKILL.md) | Review test code as a test expert and python packaging specialist |
<!-- END CLAUDE-CODE SKILLS -->

### Cursor

<!-- BEGIN CURSOR SKILLS -->
| Skill | Description |
|-------|-------------|
| [pr-reading-order](cursor/skills/pr-reading-order/SKILL.md) | Suggest the best reading order to understand and review a PR's code changes |
| [refactor-analysis](cursor/skills/refactor-analysis/SKILL.md) | This skill should be used when the user asks to "analyze a refactoring", "check for structural regressions", "review refactoring PR", "check refactor quality", or needs analysis of DRY violations, abstraction bypasses, behavioral changes, API compatibility, cache safety, or clean code issues in refactored code. |
<!-- END CURSOR SKILLS -->

## License

Apache License 2.0
