---
name: code-review
description: Review code changes as an expert maintainer against project standards
user-invocable: true
---

As a maintainer of the repo, an expert python programmer and software architect, review the code.

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

## Cross-check linked issues

After determining what to review, check whether the change references a GitHub issue (e.g., `Closes: #123`, `Fixes #123`, `Resolves #123`, or a `#123` mention in the commit message or PR body).

If a linked issue is found:
1. Fetch the issue and all its comments using `gh issue view <number> --comments`
2. Review the discussion for:
   - **Requirements or acceptance criteria** mentioned by maintainers — verify the code change actually satisfies them
   - **Edge cases or concerns** raised in comments — check whether they are addressed
   - **Design decisions or rejected approaches** — flag if the code contradicts an agreed-upon direction
   - **Scope** — flag if the change does more or less than what the issue describes
3. Include an **"Issue alignment"** section in the review output summarizing whether the change fulfills the issue requirements, noting any gaps or deviations

## Preparation

Before reviewing, read these project files to understand the standards:
- `CONTRIBUTING.md` — comprehensive coding standards, design patterns, and quality expectations
- `CLAUDE.md` — essential rules and quick reference

## Review criteria

Evaluate the code changes against the project's standards, focusing on:

1. **Correctness** — Logic errors, edge cases, off-by-one errors, race conditions
2. **Architecture** — Design coherence, separation of concerns, follows existing patterns in the codebase
3. **Type safety** — Complete type annotations, proper use of `X | None` syntax, mypy compliance
4. **Error handling** — Specific exception types, exception chaining (`raise X from err`), actionable messages
5. **Testing** — Adequate coverage, Arrange/Act/Assert pattern, `test_<behavior>()` naming
6. **Imports** — All at top of file (no local imports), PEP 8 organization
7. **Documentation** — Docstrings on public APIs, clear and imperative
8. **Logging** — Uses `req_ctxvar_context()` where appropriate, correct log levels
9. **Security** — No injection risks, safe file handling, no secrets in code
10. **Performance** — Unnecessary allocations, N+1 patterns, blocking calls

## Output format

Keep the output concise and easy to understand. Use short, direct sentences. Avoid verbose explanations — state the problem, show the location, and suggest the fix.

For each finding, report:
- **Severity**: Critical / Warning / Note
- **Location**: file path and line number(s)
- **Issue**: what's wrong
- **Suggestion**: how to fix it

End with a summary: total findings by severity and an overall assessment of the change quality.
