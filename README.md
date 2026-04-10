# AI Agent Skills

A plugin marketplace of reusable skills for Claude Code, plus standalone skills for Cursor.

## Structure

```
.claude-plugin/marketplace.json         # Plugin marketplace catalog
plugins/<name>/                         # Claude Code plugins
  .claude-plugin/plugin.json            # Plugin manifest
  skills/<name>/SKILL.md                # Plugin skill
cursor/skills/<name>/SKILL.md           # Cursor skills (symlink install)
general/                                # Tool-agnostic prompts (adapt as needed)
```

## Installation

### Claude Code (Plugin Marketplace)

Add the marketplace and install individual plugins:

```
/plugin marketplace add LalatenduMohanty/ai-agent-skills
/plugin install code-review@ai-agent-skills
/plugin install doc-review@ai-agent-skills
/plugin install pr-reading-order@ai-agent-skills
/plugin install refactor-analysis@ai-agent-skills
/plugin install test-review@ai-agent-skills
```

Or from the CLI:

```bash
claude plugin marketplace add LalatenduMohanty/ai-agent-skills
claude plugin install code-review@ai-agent-skills
```

### Cursor

Symlink individual skills or the entire skills directory:

```bash
# All Cursor skills
ln -s /path/to/ai-agent-skills/cursor/skills/* ~/.cursor/skills/

# Single skill
ln -s /path/to/ai-agent-skills/cursor/skills/refactor-analysis ~/.cursor/skills/refactor-analysis
```

## Available Plugins (Claude Code)

<!-- BEGIN PLUGINS -->
| Plugin | Description |
|--------|-------------|
| [code-review](plugins/code-review/skills/code-review/SKILL.md) | Review code changes as an expert maintainer against project standards |
| [doc-review](plugins/doc-review/skills/doc-review/SKILL.md) | Review documentation changes as a documentation and technical writing expert |
| [pr-reading-order](plugins/pr-reading-order/skills/pr-reading-order/SKILL.md) | Suggest the best reading order to understand and review a PR's code changes |
| [refactor-analysis](plugins/refactor-analysis/skills/refactor-analysis/SKILL.md) | This skill should be used when the user asks to "analyze a refactoring", "check for structural regressions", "review refactoring PR", "check refactor quality", or needs analysis of DRY violations, abstraction bypasses, behavioral changes, API compatibility, cache safety, or clean code issues in refactored code. |
| [test-review](plugins/test-review/skills/test-review/SKILL.md) | Review test code as a test expert and python packaging specialist |
<!-- END PLUGINS -->

### Cursor Skills

<!-- BEGIN CURSOR SKILLS -->
| Skill | Description |
|-------|-------------|
| [pr-reading-order](cursor/skills/pr-reading-order/SKILL.md) | Suggest the best reading order to understand and review a PR's code changes |
| [refactor-analysis](cursor/skills/refactor-analysis/SKILL.md) | This skill should be used when the user asks to "analyze a refactoring", "check for structural regressions", "review refactoring PR", "check refactor quality", or needs analysis of DRY violations, abstraction bypasses, behavioral changes, API compatibility, cache safety, or clean code issues in refactored code. |
<!-- END CURSOR SKILLS -->

## Development

The skills tables in this README are auto-generated from `SKILL.md` frontmatter. To update them after adding or modifying a plugin:

```bash
./scripts/update-readme-skills.sh
```

To enable the pre-commit hook that checks tables are up to date:

```bash
git config core.hooksPath .githooks
```

## Migration from Symlinks

If you previously installed Claude Code skills via symlink from `claude-code/skills/`, see [claude-code/MIGRATED.md](claude-code/MIGRATED.md) for migration instructions.

## License

Apache License 2.0
