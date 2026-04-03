---
name: test-review
description: Review test code as a test expert and python packaging specialist
user-invocable: true
---

As a test expert, test-architect and python packaging expert, review the code.

## Determine what to review

Based on `$ARGUMENTS`:
- **If empty:** Review the latest commit on the current branch using `git diff HEAD~1..HEAD`
- **If a commit SHA:** Review that commit using `git show $ARGUMENTS`
- **If a PR URL:**
  1. Check out the PR locally: `gh pr checkout $ARGUMENTS`
  2. Perform the review on the checked-out code (see criteria below)
  3. When the review is complete, inform the user. When the user confirms the review is done:
     - Note the PR branch name: `git rev-parse --abbrev-ref HEAD`
     - Switch back to main: `git checkout main`
     - Delete the local PR branch: `git branch -D <pr-branch>`

## Preparation

Before reviewing, read these project files to understand the standards:
- `CONTRIBUTING.md` — comprehensive coding standards, testing patterns, and quality expectations
- `CLAUDE.md` — essential rules and quick reference
- `tests/conftest.py` — shared fixtures and test infrastructure

## Review criteria

Evaluate the test changes (and any missing tests for production code changes), focusing on:

1. **Coverage** — Are all new/changed code paths tested? Are edge cases covered? Are error paths exercised?
2. **Test structure** — Arrange/Act/Assert pattern, `test_<behavior>()` naming, one assertion concept per test
3. **Fixtures** — Proper use of `tmp_path`, `testdata_path`, `tmp_context`, `cli_runner` from conftest.py; no fixture duplication
4. **Isolation** — Tests don't depend on execution order, no shared mutable state, proper mocking boundaries
5. **Assertions** — Specific assertions (not just `assert result`), meaningful failure messages, correct expected values
6. **Mocking** — Mocking at the right level, not over-mocking, patching in the correct module namespace
7. **Python packaging specifics** — Correct handling of wheel metadata, dependency specs, version comparisons, platform tags
8. **Parametrization** — Related test cases use `@pytest.mark.parametrize` instead of copy-paste
9. **Test data** — Uses `testdata/` fixtures where appropriate, no hardcoded paths, clean temp file usage
10. **Maintainability** — Tests are readable, not brittle, will survive refactoring of internals

## Output format

Keep the output concise and easy to understand. Use short, direct sentences. Avoid verbose explanations — state the problem, show the location, and suggest the fix.

For each finding, report:
- **Severity**: Critical / Warning / Note
- **Location**: file path and line number(s)
- **Issue**: what's wrong
- **Suggestion**: how to fix it

End with a summary: total findings by severity and an overall assessment of the test quality.
