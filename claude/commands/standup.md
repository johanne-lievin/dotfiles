---
description: Generate a daily standup summary from recent git activity
---

# Daily Standup Generator

Run `git log --since="yesterday" --oneline --all --author="$(git config user.name)"` to get recent commits.

Also check `git diff --stat HEAD~5..HEAD` for a broader picture if yesterday had no commits.

Format the output as:

```
## Yesterday
- [bullet per meaningful commit, grouped by theme, plain English — not commit hashes]

## Today
[leave blank — user fills this in]

## Blockers
[leave blank unless user mentions one]
```

Rules:
- Merge commits and `chore:` / `fix: typo` commits don't need to be listed
- Group related commits into one bullet
- Use plain English, not ticket IDs or technical jargon
- Keep each bullet under 80 chars
- If no commits, say "No commits — was in meetings / reviewing / planning"
