---
title: "How to Run Two Codex Accounts on macOS"
short_title: "Two accounts on macOS"
description: "Run two Codex desktop accounts at the same time by isolating both Codex state and the Electron data directory."
date: 2026-07-26
last_modified_at: 2026-07-26
intent: "Run two accounts"
category: "Desktop setup"
level: "Intermediate"
tested_on: "Codex desktop, macOS"
time: "10 minutes"
field_note: "Verified on both a MacBook and Mac Studio with two simultaneous main processes."
slug: two-accounts-macos
keywords: [Codex multiple accounts, Codex macOS, CODEX_HOME, user-data-dir]
related: [second-instance-not-opening, codex-home, config-toml]
---

## The working setup

`CODEX_HOME` isolates Codex configuration and authentication. Electron still uses its normal application data directory, including the single-instance lock. A simultaneous second desktop process needs both directories to be different.

```zsh
mkdir -p "$HOME/.codex-work"
mkdir -p "$HOME/Library/Application Support/Codex Second"

open -n -a Codex \
  --env "CODEX_HOME=$HOME/.codex-work" \
  --args "--user-data-dir=$HOME/Library/Application Support/Codex Second"
```

Sign into the second account in the new window. Later launches with the same paths should reuse that account.

## What each option changes

| Option | Responsibility |
| --- | --- |
| `-n` | Asks macOS to launch another application instance |
| `CODEX_HOME` | Separates Codex configuration, authentication, logs, and sessions |
| `--user-data-dir` | Separates Electron data and its single-instance lock |

Using only `CODEX_HOME` can still focus the first window instead of starting a second process.

## Verify both processes

```zsh
pgrep -alf "ChatGPT.app/Contents/MacOS/ChatGPT"
```

Look for two main processes. The second process should include:

```text
--user-data-dir=/Users/you/Library/Application Support/Codex Second
```

Finally, open the profile menu in each window. Each window should show the intended account.

## Keep the profiles private

Do not place either profile directory in a repository or public sync folder. Create fresh directories and sign in normally on every Mac.

For permanent Dock icons and the complete Script Editor setup, read [Two Codex Accounts, Two Dock Icons on macOS](/posts/two-codex-accounts-two-dock-icons-macos).

