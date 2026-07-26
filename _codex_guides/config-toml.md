---
title: "Where Codex config.toml Lives and Which File Wins"
short_title: "config.toml locations"
description: "Place personal and project Codex configuration in the correct file and understand how scoped settings are resolved."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Configure Codex"
category: "Configuration"
level: "Beginner"
tested_on: "Codex CLI, IDE, and desktop"
time: "7 minutes"
field_note: "The CLI, IDE extension, and desktop app share the same Codex configuration layers."
slug: config-toml
keywords: [Codex config.toml, Codex configuration, .codex config, Codex settings]
related: [codex-home, agents-md, sandbox-approvals]
---

## Use the narrowest configuration scope

Personal defaults belong in:

```text
~/.codex/config.toml
```

Repository-specific settings belong in:

```text
your-repository/.codex/config.toml
```

A project file is the better place for settings that should travel with one trusted repository. Personal defaults should not be copied into every project.

## A minimal personal configuration

```toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
```

This lets Codex work inside the active workspace and request approval when it needs to cross the configured boundary.

## A project-specific configuration

Create the directory at the repository root:

```zsh
mkdir -p .codex
```

Then add only settings the project genuinely needs:

```toml
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = false
```

Keep secrets out of `config.toml`. Use environment variables or the secret mechanism supported by the service you connect.

## Verify before adding more

Open the repository from its root, start a fresh Codex task, and ask it to report its active sandbox and approval settings. Test a harmless read and a temporary workspace write.

Configuration controls behavior. `AGENTS.md` controls durable instructions such as build commands and code conventions. Use the [AGENTS.md guide](/guides/codex/agents-md/) when the requirement is guidance rather than a runtime setting.

Source: [Codex configuration basics](https://learn.chatgpt.com/docs/config-file/config-basic)

