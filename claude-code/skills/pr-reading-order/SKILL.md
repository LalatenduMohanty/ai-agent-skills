---
name: pr-reading-order
description: Suggest the best reading order to understand and review a PR's code changes
argument-hint: [commit-sha | pr-url]
user-invocable: true
allowed-tools: Bash(git *) Bash(gh *) Read Grep Glob
---

As an expert software architect, analyze a PR and produce a recommended reading order that helps a reviewer understand the change as efficiently as possible.

## Determine what to analyze

Based on `$ARGUMENTS`:
- **If empty:** Analyze the latest commit on the current branch using `git diff HEAD~1..HEAD`
- **If a commit SHA:** Analyze that commit using `git show $ARGUMENTS`
- **If a PR URL:**
  1. Determine the PR number from the URL
  2. Check out the PR locally: `gh pr checkout <number>`
  3. Determine the base branch: `gh pr view <number> --json baseRefName --jq .baseRefName`
  4. Perform the analysis using the base branch instead of `main`
  5. When the analysis is complete, inform the user that the PR branch is still checked out and they can switch back when ready

## Gather context

Determine the base branch:
- For PR URLs: use the base branch from `gh pr view`
- For commits on a branch: use `git merge-base --fork-point main HEAD` or fall back to `main`

Then:
1. Get the PR metadata: `gh pr view <number> --json title,body,commits`
2. Get the commit list in chronological order: `git log <base>..HEAD --oneline --reverse`
3. Get the diff stat: `git diff <base>...HEAD --stat`
4. Check diff size: `git diff <base>...HEAD --shortstat`
   - If under 500 lines changed, read the full diff: `git diff <base>...HEAD`
   - If larger, read per-commit diffs selectively, starting with commits that introduce new abstractions
5. For each commit, get its changed files: `git show <sha> --stat --oneline`
6. Read `CONTRIBUTING.md` and `CLAUDE.md` to understand project conventions

## Analysis

Follow Google's three-step CL navigation approach, adapted for reading-order recommendations:

### Step 0: Deep understanding for beginner-friendly explanation

Before analyzing reading order, build a thorough understanding of the change so you can explain it to someone new to both fromager and Python:

1. **Read the actual changed code** — not just diffs, but the full files around the changed areas. Understand what each modified function, class, or module does in the broader system.
2. **Understand the fromager concepts involved** — e.g., what is a resolver, what is a build context, what does bootstrapping mean, what are package settings. Read related unchanged code if needed to grasp the component's role.
3. **Identify Python concepts a beginner might not know** — e.g., decorators, context managers, threading/locks, generators, dataclasses, Pydantic models, type annotations, `__init__` patterns.
4. **Build a narrative** — construct a plain-language explanation of what the code was doing before, what it does after this change, and why the change matters. Use analogies where they help. Define jargon inline. Aim for 2-4 paragraphs for a typical change; scale up for complex multi-commit PRs.

### Step 1: Broad view — understand purpose and scope

Building on the code understanding from Step 0, now focus on *reading-order strategy* by assessing scope and structure:
- Read the PR description, linked issues, and any discussion
- Form an **expected model**: what would a reasonable implementation look like?
- Assess the change size to choose a reading strategy:
  - **Small (<~200 LOC):** linear reading is fine — files in dependency order
  - **Medium:** difficulty-based — start with the core change, trace outward
  - **Large (multi-commit):** chunking — break into meaningful units by commit or functional area

### Step 2: Identify the core change

Find the files with the most significant logic changes — these are the foundation for understanding everything else:
- Which files define new types, functions, or classes that other changed files consume?
- Which files introduce new behavior vs. adapting existing code?
- Build a dependency graph: files that introduce abstractions should be read before files that consume them

### Step 3: Classify each commit

For multi-commit PRs, classify each commit:
- **Core change** — introduces the main new behavior or abstraction
- **Adapter/consumer** — updates callers to use the new code
- **Rename/cosmetic** — pure renames, comment updates, formatting
- **Cleanup** — removes old code, dead code, deprecated hooks
- **Tests** — adds or updates tests
- **Docs** — documentation-only changes

### Step 4: Determine reading order

Apply these principles:
1. **Core first**: start with the files containing the most significant logic changes — this gives context for everything else (Google's Step 2)
2. **Bottom-up by dependency**: within the core, read the lowest-level abstractions first, then work up to consumers and callers
3. **Tests alongside source**: pair test files with their corresponding source files — tests clarify intent and serve as executable specification
4. **Group related files**: within a commit, order files so the reader sees definitions before usages
5. **Defer cosmetic changes**: pure renames, doc updates, and cleanup should be read last — these are important but don't aid comprehension of the main change

For multi-commit PRs, the reading order can cross commit boundaries if that produces a clearer understanding (e.g., read the core file from commit 1, then its consumer from commit 3, then the rename from commit 2).

### Step 5: Note surrounding context worth reading

Look beyond the diff — check if understanding the change requires reading unchanged code:
- Are there existing abstractions, base classes, or interfaces the changed code extends?
- Does the change duplicate patterns found elsewhere in the codebase?
- List any unchanged files the reviewer should open alongside the diff for context

## Output format

Keep the output scannable. A reviewer should grasp the plan in under 30 seconds, then use it as a checklist while reading.

**Understanding this change** — A detailed, beginner-friendly explanation placed at the very beginning of the output. Write this as if the reader is new to fromager and new to Python programming. Organize it in this order:

1. **The component** — What part of fromager is being changed and what role it plays in the system. Use plain language and analogies (e.g., "The resolver is the part of fromager that figures out which version of a package to use — like a librarian finding the right edition of a book").
2. **Before and after** — What the code was doing before this change and what it does after, in concrete terms. Focus on behavior, not implementation details.
3. **Python concepts** — If the change uses non-trivial Python patterns (e.g., threading locks, context managers, decorators, dataclasses), explain each briefly so a beginner can follow the code.

Guidelines:
- Avoid jargon, or define it inline when unavoidable
- Use analogies where they make complex ideas easier to grasp
- Aim for 2-4 short paragraphs for a typical change; scale up for complex multi-commit PRs
- Use short paragraphs and plain sentences — no walls of text

Use a horizontal rule (`---`) after this section to visually separate it from the review-focused output below.

**Mental model** — one sentence summarizing what the PR does and why.

**At a glance** — a compact table:

| | |
|---|---|
| Size | +N / -N lines, N files |
| Complexity | low / medium / high |
| Strategy | linear / core-first / chunked |

**Reading order** — a numbered list using this format:

```
### N. Short label

- Commit: `commit-sha` commit summary
- Files: `path/a.py`, `path/b.py`
- What to look for: A concise and easy to understand explanation on what to focus on.
  If there are multiple points, use a nested bullet list:
  - First point
  - Second point
```

Use a blank line between steps for visual breathing room. Only add a "- Context:" line if the reviewer needs to open an unchanged file alongside the diff — don't add it to every step.

**Skim** — one short paragraph or bullet list of mechanical changes (renames, import reordering, test fixture updates) the reviewer can scan quickly.

**Watch out** — a bullet list (3-5 items max) of areas deserving close scrutiny: subtle logic, safety assumptions, missing tests, API/plugin breaking changes, or pattern deviations. Each bullet should be one sentence.
