---
title: "How to Keep Separate Codex Configuration Profiles"
short_title: "Separate config profiles"
description: "Create stable Codex profiles for different workflows without repeatedly editing the default config.toml."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Separate workflows"
category: "Configuration"
level: "Intermediate"
tested_on: "Codex CLI and desktop"
time: "8 minutes"
field_note: "A stable profile directory is easier to reason about than scripts that rewrite one shared configuration."
slug: profile-config
keywords: [Codex profiles, separate Codex config, CODEX_HOME profiles, Codex workflows]
related: [codex-home, config-toml, sandbox-approvals]
---

## Separate state by workflow

The simplest hard boundary is a dedicated `CODEX_HOME`:

```zsh
mkdir -p "$HOME/.codex-review"
mkdir -p "$HOME/.codex-build"
```

Create a configuration for review:

```toml
# ~/.codex-review/config.toml
approval_policy = "on-request"
sandbox_mode = "read-only"
```

Create a configuration for implementation:

```toml
# ~/.codex-build/config.toml
approval_policy = "on-request"
sandbox_mode = "workspace-write"
```

## Launch the intended profile

```zsh
CODEX_HOME="$HOME/.codex-review" codex
```

Or:

```zsh
CODEX_HOME="$HOME/.codex-build" codex
```

Shell functions make the choice visible:

```zsh
codex-review() {
  CODEX_HOME="$HOME/.codex-review" codex "$@"
}

codex-build() {
  CODEX_HOME="$HOME/.codex-build" codex "$@"
}
```

## Avoid configuration drift

Document why each profile exists and keep its path stable. Do not copy authentication files between people or commit profile directories.

Repository `.codex/config.toml` still represents project scope. A separate `CODEX_HOME` represents user or workflow scope. Test the effective permissions in a disposable repository before relying on the profile.

