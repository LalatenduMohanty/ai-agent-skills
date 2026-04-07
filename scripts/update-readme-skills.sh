#!/usr/bin/env bash
#
# Regenerate the "Available Skills" tables in README.md from SKILL.md frontmatter.
#
# Usage:
#   ./scripts/update-readme-skills.sh          # update README.md in place
#   ./scripts/update-readme-skills.sh --check  # exit 1 if README.md is out of date

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
README="$REPO_ROOT/README.md"

# Clean up temp files on exit
TMPFILES=()
cleanup() { rm -f "${TMPFILES[@]}"; }
trap cleanup EXIT

make_tmpfile() {
  local f
  f="$(mktemp)"
  TMPFILES+=("$f")
  echo "$f"
}

# --- helpers ----------------------------------------------------------------

# Extract name and description from a SKILL.md's YAML frontmatter.
# Output: one line of tab-separated values: name<TAB>description<TAB>filepath
parse_skill() {
  local file="$1"
  local name="" description=""
  local in_frontmatter=false

  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      if $in_frontmatter; then
        break
      fi
      in_frontmatter=true
      continue
    fi

    if $in_frontmatter; then
      case "$line" in
        name:*)
          name="${line#name:}"
          name="${name# }"
          ;;
        description:*)
          description="${line#description:}"
          description="${description# }"
          ;;
      esac
    fi
  done < "$file"

  if [[ -n "$name" && -n "$description" ]]; then
    printf '%s\t%s\t%s\n' "$name" "$description" "$file"
  fi
}

# Build a markdown table for all skills under a tool directory (e.g. claude-code, cursor).
generate_table() {
  local tool_dir="$1"
  local entries=()

  for skill_file in "$REPO_ROOT/$tool_dir"/skills/*/SKILL.md; do
    [[ -f "$skill_file" ]] || continue
    local entry
    entry="$(parse_skill "$skill_file")"
    [[ -n "$entry" ]] && entries+=("$entry")
  done

  # Sort entries alphabetically by skill name (first field)
  local sorted=()
  if [[ ${#entries[@]} -gt 0 ]]; then
    readarray -t sorted < <(printf '%s\n' "${entries[@]}" | sort -t$'\t' -k1,1)
  fi

  echo "| Skill | Description |"
  echo "|-------|-------------|"
  for entry in "${sorted[@]}"; do
    local name description file rel_path
    name="$(printf '%s' "$entry" | cut -d$'\t' -f1)"
    description="$(printf '%s' "$entry" | cut -d$'\t' -f2)"
    file="$(printf '%s' "$entry" | cut -d$'\t' -f3)"
    rel_path="${file#"$REPO_ROOT/"}"
    echo "| [$name]($rel_path) | $description |"
  done
}

# Replace everything between begin/end marker comments with new content.
# Keeps the marker lines themselves; only the content between them is replaced.
replace_section() {
  local begin_marker="$1"
  local end_marker="$2"
  local new_content="$3"
  local file="$4"
  local tmp
  tmp="$(make_tmpfile)"

  local inside=false
  while IFS= read -r line; do
    if [[ "$line" == *"$begin_marker"* ]]; then
      echo "$line" >> "$tmp"
      echo "$new_content" >> "$tmp"
      inside=true
    elif [[ "$line" == *"$end_marker"* ]]; then
      echo "$line" >> "$tmp"
      inside=false
    elif ! $inside; then
      echo "$line" >> "$tmp"
    fi
  done < "$file"

  mv "$tmp" "$file"
}

# Apply all table replacements to the given file.
update_all_tables() {
  local target="$1"
  replace_section "<!-- BEGIN CLAUDE-CODE SKILLS -->" "<!-- END CLAUDE-CODE SKILLS -->" "$claude_code_table" "$target"
  replace_section "<!-- BEGIN CURSOR SKILLS -->" "<!-- END CURSOR SKILLS -->" "$cursor_table" "$target"
}

# --- main -------------------------------------------------------------------

claude_code_table="$(generate_table "claude-code")"
cursor_table="$(generate_table "cursor")"

if [[ "${1:-}" == "--check" ]]; then
  tmp_readme="$(make_tmpfile)"
  cp "$README" "$tmp_readme"

  update_all_tables "$tmp_readme"

  if diff -q "$README" "$tmp_readme" > /dev/null 2>&1; then
    echo "README.md skills tables are up to date."
  else
    echo "README.md skills tables are out of date. Run ./scripts/update-readme-skills.sh to fix."
    diff --color=auto "$README" "$tmp_readme" || true
    exit 1
  fi
else
  update_all_tables "$README"
  echo "README.md skills tables updated."
fi
