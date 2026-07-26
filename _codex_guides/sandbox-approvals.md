---
title: "Codex Sandbox Modes and Approval Policies Explained"
short_title: "Sandbox and approvals"
description: "Choose a Codex sandbox boundary and approval policy without giving routine work more access than it needs."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Choose permissions"
category: "Security"
level: "Intermediate"
tested_on: "Codex CLI, IDE, and desktop"
time: "8 minutes"
field_note: "The sandbox defines what commands can touch. The approval policy defines when Codex pauses to ask."
slug: sandbox-approvals
keywords: [Codex sandbox, Codex approvals, workspace-write, read-only, danger-full-access]
related: [config-toml, non-interactive-ci, agents-md]
---

## Two controls, two jobs

The sandbox is the technical boundary around spawned commands. The approval policy decides when Codex must pause before an action.

Common sandbox modes:

| Mode | Use |
| --- | --- |
| `read-only` | Investigation, review, or planning without edits |
| `workspace-write` | Normal repository work inside configured writable roots |
| `danger-full-access` | Trusted work that genuinely needs unrestricted command access |

For ordinary development, start with:

```toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
```

## Network access is separate

`workspace-write` does not imply command-line network access. Configure it explicitly:

```toml
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = true
```

Enable it only when repository commands need the network. Web search and spawned command networking are separate capabilities.

## One-off CLI overrides

```zsh
codex --sandbox read-only --ask-for-approval on-request
```

For normal editing:

```zsh
codex --sandbox workspace-write --ask-for-approval on-request
```

Avoid making unrestricted access a permanent default. Use it for a clearly scoped trusted task, then return to a narrower boundary.

## Verify the boundary

Ask Codex to:

1. Read a tracked file.
2. Create a temporary file inside the repository.
3. Access a path outside the workspace.

The first two should match the selected mode. The third should remain blocked or require approval unless explicitly configured.

Source: [Codex sandbox and approvals](https://learn.chatgpt.com/docs/agent-approvals-security)

