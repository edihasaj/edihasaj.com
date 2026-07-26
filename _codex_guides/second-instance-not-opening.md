---
title: "Codex Second Instance Not Opening on macOS"
short_title: "Second instance not opening"
description: "Fix a second Codex launch that focuses the existing window instead of opening a separate desktop process."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Fix second launch"
category: "Troubleshooting"
level: "Intermediate"
tested_on: "Codex desktop, macOS"
time: "5 minutes"
field_note: "The failure reproduced on two Macs when CODEX_HOME was isolated but Electron data was not."
slug: second-instance-not-opening
keywords: [Codex second instance, Codex not opening, Electron single instance, Codex macOS]
related: [two-accounts-macos, codex-home, config-toml]
---

## Symptom

You launch Codex with a second `CODEX_HOME`, but macOS brings the existing Codex window forward. No second main process remains running.

The Codex profile moved. The Electron single-instance lock did not.

## Fix the desktop data directory

Give the second launch a dedicated Electron data directory:

```zsh
mkdir -p "$HOME/.codex-work"
mkdir -p "$HOME/Library/Application Support/Codex Second"

open -n -a Codex \
  --env "CODEX_HOME=$HOME/.codex-work" \
  --args "--user-data-dir=$HOME/Library/Application Support/Codex Second"
```

All three parts matter:

1. `open -n` requests another app instance.
2. `CODEX_HOME` separates Codex state.
3. `--user-data-dir` separates Electron state.

## Diagnose the launcher

Inspect the active processes:

```zsh
pgrep -alf "ChatGPT.app/Contents/MacOS/ChatGPT"
```

If only one main process appears, check the launcher for:

- A missing `-n`.
- A quoted `--user-data-dir` that is not passed after `--args`.
- Both launchers pointing to the same desktop data directory.
- A different second-profile path on every launch.

## Confirm persistence

Sign into the second window, quit it, then run the same command again. The second account should remain signed in. If it does not, confirm that the `CODEX_HOME` and `--user-data-dir` paths are identical across launches.

