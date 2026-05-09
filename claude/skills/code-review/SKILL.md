---
name: code-review
description: >
  Use when the user asks to "review", "check", "look at", or "critique" their
  code. Also triggers on "is this good?" or "any issues with this?".
---

# Code Review Skill

## Review order (most impactful first)

### 1. Correctness
- Does it do what it claims?
- Are edge cases handled? (empty input, nil/null, 0, max values, concurrent access)
- Are errors handled and propagated correctly?
- Are there off-by-one errors?

### 2. Security
- SQL injection? (use parameterized queries)
- XSS? (escape user output)
- Path traversal? (sanitize file paths)
- Secrets in code? (should be env vars)
- Auth/authz checks present?

### 3. Performance
- N+1 queries?
- Unbounded loops on user input?
- Missing indexes for query patterns?
- Memory leaks (unclosed resources)?

### 4. Maintainability
- Is naming clear and consistent?
- Is the function doing one thing?
- Is there duplication that should be extracted?
- Are magic numbers named as constants?
- Is error handling consistent with the codebase?

### 5. Tests
- Are happy paths covered?
- Are error paths covered?
- Are tests testing behaviour, not implementation?

## Output format
```
## Summary
One sentence on overall quality.

## Issues

### 🔴 Critical (must fix)
- [file:line] Description — why it matters, suggested fix

### 🟡 Warnings (should fix)
- [file:line] Description

### 🟢 Suggestions (nice to have)
- [file:line] Description

## What's good
Brief callout of things done well (important for morale).
```
