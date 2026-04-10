---
name: refactor-analysis
description: This skill should be used when the user asks to "analyze a refactoring", "check for structural regressions", "review refactoring PR", "check refactor quality", or needs analysis of DRY violations, abstraction bypasses, behavioral changes, API compatibility, cache safety, or clean code issues in refactored code.
user-invocable: true
---

As an expert software architect, analyze the refactoring for structural regressions -- cases where the refactor **introduces new problems while solving old ones**.

## Determine what to review

Based on `$ARGUMENTS`:
- **If empty:** Review the latest commit on the current branch using `git diff HEAD~1..HEAD`
- **If a commit SHA:** Review that commit using `git show $ARGUMENTS`
- **If a PR URL:**
  1. Check out the PR locally: `gh pr checkout $ARGUMENTS`
  2. Perform the analysis on the checked-out code
  3. When the review is complete, inform the user. When the user confirms:
     - Switch back to main: `git checkout main`
     - Delete the local PR branch: `git branch -D <pr-branch>`

## Cross-check linked issues

If the change references a GitHub issue (`Closes: #123`, `Fixes #123`, `Resolves #123`):
1. Fetch it with `gh issue view <number> --comments`
2. Verify the refactoring satisfies stated requirements, stays in scope, addresses raised concerns, and avoids rejected approaches
3. Include an **"Issue alignment"** section in the output

## Preparation

Before reviewing, read these project files:
- `CONTRIBUTING.md` — coding standards, design patterns, and quality expectations
- `CLAUDE.md` — essential rules and quick reference
- `pyproject.toml` — entry points, hooks, and plugin configuration

## Analysis

### Step 1: Map the call graph before and after

For each changed function, use `git show main:<filepath>` to trace:
- What called it before vs now?
- What did it call before vs now?
- Did the layering change (high-level module now calling low-level internals)?

### Step 2: Evaluate six dimensions

1. **DRY** -- Same multi-line pattern (5+ lines) in 3+ places? A function inlined and its body copy-pasted to every call site? A helper created but callers also duplicate its logic?

2. **Abstraction** -- Higher-level module bypassing public APIs to call lower-level internals? For each changed call site, ask: "Could this caller use the existing public API instead?"

3. **Behavioral equivalence** -- Return types changed (single value vs list)? Exception types differ? Edge cases (empty input, None, error paths) behave differently? Side effects (logging, metrics, cache writes) dropped?

4. **API/plugin compatibility** -- Functions, classes, or entry points removed? Hooks no longer invoked (check `pyproject.toml`)? Signatures changed without backward-compatible aliases?

5. **Cache/state safety** -- Mutable data stored in or returned from caches by reference? Callers able to mutate cached objects? Global state modified as a side effect?

6. **Clean code** --
   - **Functions**: Grew longer, took on multiple responsibilities, or added flag arguments?
   - **Naming**: Less intention-revealing (e.g., `get_` method now has side effects)?
   - **Side effects**: Functions silently modifying state beyond their return value?
   - **Error handling**: Bare `except:`, swallowed exceptions, or error codes replacing exceptions?
   - **Dead code**: Unused imports, unreachable branches, or commented-out blocks left behind?
   - **Comments**: Compensating for unclear code instead of making the code itself clearer?

## Output format

Keep the output concise and easy to understand. Use short, direct sentences. Avoid verbose explanations — state the problem, show the location, and suggest the fix.

For each finding:
- **Severity**: Critical / Warning / Note
- **Dimension**: DRY / Abstraction / Behavioral / API / Cache / Clean Code
- **Location**: file path and line number(s)
- **Issue**: what the refactoring introduced or broke
- **Suggestion**: how to fix it

End with:
1. **Before/After summary table** showing the architectural change
2. **Overall verdict**: Does the refactoring make the code flow better or worse?
3. **Total findings by severity**
