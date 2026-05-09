---
name: git-workflow
description: >
  Use when the user wants to commit changes, write a commit message, create a
  PR description, review staged changes, or do anything git-workflow related.
  Triggers on: "commit", "PR", "pull request", "what changed", "write a commit".
---

# Git Workflow Skill

## Commit messages
Always use Conventional Commits format:
```
<type>(<scope>): <short summary>

[optional body — what and WHY, not how]

[optional footer: BREAKING CHANGE, Closes #123]
```

Types: `feat` | `fix` | `refactor` | `perf` | `test` | `docs` | `chore` | `ci`

Rules:
- Subject line ≤ 72 chars, lowercase, no period
- Body explains *why*, not *what* (the diff shows what)
- Reference issues in footer: `Closes #42`
- One logical change per commit — split if needed

## Workflow for committing

1. Run `git diff --staged` to understand what's staged
2. If nothing staged, run `git status` and ask which files to stage
3. Write the commit message following the format above
4. Show the message and ask for confirmation before running `git commit`
5. Never `git push` unless explicitly asked

## PR description template

```markdown
## What
<!-- One sentence summary of the change -->

## Why
<!-- Context: what problem this solves, why now -->

## How
<!-- Key implementation decisions worth calling out -->

## Testing
<!-- How to verify this works -->

## Screenshots / recordings
<!-- If UI changed -->
```

## Code review checklist (when asked to review)
- [ ] Does it do what it says it does?
- [ ] Are errors handled?
- [ ] Are edge cases covered?
- [ ] Is it testable?
- [ ] Are there security implications?
- [ ] Does naming make intent clear?
