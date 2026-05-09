---
description: Capture a reusable skill from the current conversation and save it to ~/.claude/skills/
---

# Capture New Skill

Look at the current conversation and identify something we worked through that could be reused.

Ask the user:
1. What should this skill be named? (lowercase-kebab-case)
2. In one sentence, when should this skill be triggered?

Then create the file `~/.claude/skills/<name>/SKILL.md` with:

```markdown
---
name: <name>
description: >
  <one-sentence trigger description>
---

# <Title>

<Distilled knowledge from this conversation: patterns, commands, pitfalls, templates>
```

Keep it practical — focus on what to DO, not theory.
After creating the file, confirm the path and tell the user to add it to their dotfiles repo.
