# Skills have moved

The Claude Code skills in this directory have been migrated to the
plugin marketplace format. They now live under `plugins/`.

## New installation (recommended)

```
/plugin marketplace add LalatenduMohanty/ai-agent-skills
/plugin install code-review@ai-agent-skills
/plugin install doc-review@ai-agent-skills
/plugin install pr-reading-order@ai-agent-skills
/plugin install refactor-analysis@ai-agent-skills
/plugin install test-review@ai-agent-skills
```

## Manual symlink users

If you previously used:

```bash
ln -s /path/to/ai-agent-skills/claude-code/skills/* ~/.claude/skills/
```

Remove the old symlinks and switch to the plugin marketplace:

```bash
# Remove old symlinks
rm -f ~/.claude/skills/code-review ~/.claude/skills/doc-review \
   ~/.claude/skills/pr-reading-order ~/.claude/skills/refactor-analysis \
   ~/.claude/skills/test-review

# Install via plugin marketplace (recommended)
/plugin marketplace add LalatenduMohanty/ai-agent-skills
/plugin install code-review@ai-agent-skills
```
