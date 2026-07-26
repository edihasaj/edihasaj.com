---
title: "How to Write an AGENTS.md File Codex Can Use"
short_title: "Write AGENTS.md"
description: "Give Codex durable repository instructions with a concise AGENTS.md covering setup, conventions, verification, and boundaries."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Create AGENTS.md"
category: "Configuration"
level: "Beginner"
tested_on: "Codex CLI, IDE, and desktop"
time: "12 minutes"
field_note: "Useful guidance is concrete and executable. Vague preferences consume context without preventing mistakes."
slug: agents-md
keywords: [AGENTS.md, Codex instructions, repository agent guide, Codex customization]
related: [config-toml, skills, sandbox-approvals]
---

## Start with what Codex must know

Put `AGENTS.md` at the repository root. Codex loads it as durable project guidance.

```markdown
# Repository guide

## Setup
- Install dependencies with `npm ci`.
- Copy `.env.example` to `.env.local`.

## Development
- Run `npm run dev`.
- Keep application code under `src/`.

## Verification
- Run `npm run lint`.
- Run `npm test`.
- Run `npm run build`.

## Boundaries
- Never commit secrets.
- Ask before changing database schemas.
```

Replace every example command with the repository's real command.

## Keep responsibilities separate

Use `AGENTS.md` for:

- Build, test, lint, and release commands.
- Architecture and file-placement rules.
- Review expectations.
- Project-specific safety boundaries.

Use `.codex/config.toml` for sandboxing, approval policy, MCP servers, and Codex runtime settings.

## Add nested instructions only when needed

A more specific `AGENTS.md` closer to a file can provide local rules for that subtree:

```text
AGENTS.md
apps/
  ios/
    AGENTS.md
```

The nested file should describe only what differs in that area. Do not repeat the entire root guide.

## Verify the file

Start a new task in the repository and ask:

```text
List the repository setup and verification commands you will follow.
```

Compare the response with `AGENTS.md`. Then give Codex a small task and confirm it runs the intended gate.

Source: [Codex AGENTS.md guidance](https://learn.chatgpt.com/docs/agent-configuration/agents-md)

