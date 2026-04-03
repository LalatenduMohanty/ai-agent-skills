---
name: doc-review
description: Review documentation changes as a documentation and technical writing expert
user-invocable: true
---

As a documentation expert, technical writer, and python packaging specialist, review the documentation.

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
   - **Requirements or acceptance criteria** mentioned by maintainers — verify the documentation change actually satisfies them
   - **Edge cases or concerns** raised in comments — check whether they are addressed
   - **Design decisions or rejected approaches** — flag if the documentation contradicts an agreed-upon direction
   - **Scope** — flag if the change does more or less than what the issue describes
3. Include an **"Issue alignment"** section in the review output summarizing whether the change fulfills the issue requirements, noting any gaps or deviations

## Preparation

Before reviewing, read these project files to understand the standards:
- `CONTRIBUTING.md` — comprehensive coding standards, design patterns, and quality expectations
- `CLAUDE.md` — essential rules and quick reference
- `docs/` directory structure — to understand existing documentation organization

## Review criteria

Evaluate the documentation changes (and any missing documentation for production code changes), focusing on:

1. **Accuracy** — Do docstrings and comments correctly describe what the code does? Are examples correct and runnable?
2. **Completeness** — Are all public APIs documented? Are new features reflected in user-facing docs? Are parameters, return values, and exceptions documented?
3. **Clarity** — Is the writing clear, concise, and unambiguous? Is jargon explained or avoided?
4. **Consistency** — Does the style match existing documentation? Are formatting conventions followed (RST vs Markdown, heading levels, etc.)?
5. **Structure** — Is information logically organized? Are cross-references and links correct? Is the docs/ table of contents updated if needed?
6. **Docstrings** — Imperative mood, present tense, complete parameter/return documentation, follows project conventions
7. **Inline comments** — Explain "why" not "what", are not stale or redundant, add genuine value
8. **README and guides** — Are getting-started instructions accurate? Are prerequisites listed? Are examples up to date?
9. **Spelling and grammar** — No typos, correct technical terminology, consistent capitalization
10. **Audience** — Is the documentation appropriate for its target audience (end users vs contributors vs maintainers)?

## Output format

Keep the output concise and easy to understand. Use short, direct sentences. Avoid verbose explanations — state the problem, show the location, and suggest the fix.

For each finding, report:
- **Severity**: Critical / Warning / Note
- **Location**: file path and line number(s)
- **Issue**: what's wrong
- **Suggestion**: how to fix it

End with a summary: total findings by severity and an overall assessment of the documentation quality.
