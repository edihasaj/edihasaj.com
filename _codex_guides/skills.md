---
title: "When to Create a Codex Skill Instead of AGENTS.md"
short_title: "Skills vs AGENTS.md"
description: "Choose between a Codex skill and repository guidance, then structure a reusable workflow that loads only when relevant."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Choose a customization"
category: "Extensions"
level: "Intermediate"
tested_on: "Codex CLI, IDE, and desktop"
time: "9 minutes"
field_note: "Put always-relevant repository facts in AGENTS.md. Put reusable task procedures in a skill."
slug: skills
keywords: [Codex skills, SKILL.md, AGENTS.md vs skill, Codex workflows]
related: [agents-md, mcp-servers, config-toml]
---

## Choose by scope

Use `AGENTS.md` when Codex should always know the rule while working in a repository.

Use a skill when the instructions describe a repeatable task that should load only when named or relevant.

| Need | Best surface |
| --- | --- |
| Repository build commands | `AGENTS.md` |
| Code placement conventions | `AGENTS.md` |
| Repeatable release workflow | Skill |
| Specialized document generation | Skill |
| Live external system access | MCP server |

## Minimal skill structure

```text
my-skill/
  SKILL.md
  scripts/
  references/
  assets/
```

`SKILL.md` should explain:

1. When the skill applies.
2. Which inputs it expects.
3. The ordered workflow.
4. Required verification.
5. Which referenced files to read.

Keep the main instructions focused. Put long reference material in `references/` and deterministic operations in `scripts/`.

## Test the trigger

Try two fresh tasks:

```text
Use my-skill to perform its intended workflow.
```

Then try an unrelated task. The skill should help with the first and stay out of the second.

If every task in one repository needs the same rule, move that rule into `AGENTS.md`. If the workflow needs private live data, connect the relevant MCP server rather than embedding that data in a skill.

Source: [Codex skills](https://learn.chatgpt.com/docs/build-skills)
