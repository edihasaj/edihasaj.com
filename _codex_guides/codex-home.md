---
title: "CODEX_HOME: What It Stores and When to Change It"
short_title: "CODEX_HOME explained"
description: "Understand the Codex state directory, create an isolated profile, and verify which configuration a process is using."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Understand CODEX_HOME"
category: "Configuration"
level: "Beginner"
tested_on: "Codex CLI and desktop, macOS"
time: "6 minutes"
field_note: "CODEX_HOME isolates Codex state. It does not by itself override Electron desktop state."
slug: codex-home
keywords: [CODEX_HOME, Codex config directory, Codex auth location, multiple Codex profiles]
related: [config-toml, two-accounts-macos, second-instance-not-opening]
---

## Default and custom locations

Codex normally uses:

```text
~/.codex
```

`CODEX_HOME` changes that root for Codex state, including configuration, authentication, logs, sessions, and installed skills.

```zsh
mkdir -p "$HOME/.codex-work"
CODEX_HOME="$HOME/.codex-work" codex
```

That command starts the CLI with an isolated profile. It does not modify the default profile.

## Create a named shell helper

Add a small function to your shell configuration:

```zsh
codex-work() {
  CODEX_HOME="$HOME/.codex-work" codex "$@"
}
```

After opening a new shell:

```zsh
codex-work
```

Use a stable directory. A temporary or changing path creates a fresh profile and can make authentication appear to disappear.

## Verify the active home

From the same shell that launches Codex:

```zsh
printf '%s\n' "${CODEX_HOME:-$HOME/.codex}"
```

Then confirm that the expected configuration exists:

```zsh
ls -la "${CODEX_HOME:-$HOME/.codex}"
```

Treat this directory as sensitive. Do not commit it, paste authentication files into tickets, or share it between people.

## Desktop limitation

For simultaneous desktop accounts, `CODEX_HOME` is only one isolation layer. The second desktop launcher also needs a distinct Electron `--user-data-dir`. Follow the [two-account macOS guide](/guides/codex/two-accounts-macos/) for that setup.

