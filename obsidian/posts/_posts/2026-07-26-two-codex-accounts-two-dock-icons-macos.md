---
share: true
layout: post
title: "How to Run Two Codex Accounts on macOS with Separate Profiles"
date: 2026-07-26
last_modified_at: 2026-07-31
published: true
filename: essay/_posts/2026-07-26-two-codex-accounts-two-dock-icons-macos
tags:
  - AI
  - Codex
  - macOS
  - tooling
  - productivity
excerpt: "Run two OpenAI Codex accounts at once on one Mac with separate profiles, logins, app data, and stable Dock icons."
faq:
  - question: "Can I run two Codex accounts at the same time on one Mac?"
    answer: "Yes. Keep the installed Codex app for the primary account and launch a second process with an isolated CODEX_HOME and Electron user-data directory."
  - question: "Why is CODEX_HOME alone not enough?"
    answer: "CODEX_HOME separates Codex configuration and authentication, while the Electron user-data directory separates desktop application state and prevents the second launch from returning to the primary process."
  - question: "Do the two Codex profiles share chats, projects, or usage limits?"
    answer: "No. Each profile uses its own ChatGPT account and local application state. This setup does not merge chats, projects, billing, or usage limits."
  - question: "Why does the Codex Second Dock icon disappear or turn blank?"
    answer: "Older Script Editor launchers can lose their Dock identity or invalidate their signature after an icon change. The native launcher in this guide embeds the icon before signing and uses a stable bundle identifier."
  - question: "Does this modify the installed Codex app?"
    answer: "No. The normal Codex installation remains unchanged. The second launcher only starts another isolated Codex process."
---

Use the installed Codex app for your primary account. You only need one custom launcher for the second account.

The second launcher needs two isolated directories:

| State | Location |
| --- | --- |
| Codex configuration and authentication | `~/.codex-work` |
| Desktop application data | `~/Library/Application Support/Codex Second` |

`CODEX_HOME` isolates Codex state. The separate `--user-data-dir` prevents Electron from handing the second launch back to the primary app.

## test the second account

Run this in Terminal:

```zsh
mkdir -p "$HOME/.codex-work"
mkdir -p "$HOME/Library/Application Support/Codex Second"

open -n -a Codex \
  --env "CODEX_HOME=$HOME/.codex-work" \
  --args "--user-data-dir=$HOME/Library/Application Support/Codex Second"
```

A second Codex window should open. Sign into your other ChatGPT account.

## create a permanent Dock launcher

The stable version is a tiny native macOS launcher. It avoids Script Editor,
does not need permission to control System Events, and keeps its identity after
Dock or Mac restarts.

Download and run the installer:

```zsh
curl -fsSL \
  https://edihasaj.com/assets/scripts/install-codex-second.zsh \
  -o "$HOME/Downloads/install-codex-second.zsh"

zsh "$HOME/Downloads/install-codex-second.zsh"
```

If `swiftc` is unavailable, install Apple's Command Line Tools first:

```zsh
xcode-select --install
```

The installer:

- creates a native `~/Applications/Codex Second.app`;
- assigns the stable bundle ID `com.edihasaj.codex-second`;
- embeds the installed ChatGPT icon before signing;
- applies a valid local ad-hoc signature;
- moves an older launcher to the Trash so it remains recoverable.

Remove an older `Codex Second` entry from the Dock. Open `~/Applications` in
Finder and drag the newly generated app beside the normal Codex icon. Keep
using the installed Codex icon for your primary account.

## verify both accounts

Open normal Codex, then click `Codex Second` in the Dock. Run:

```zsh
pgrep -alf "ChatGPT.app/Contents/MacOS/ChatGPT"
```

You should see two main processes. The second includes:

```text
--user-data-dir=/Users/you/Library/Application Support/Codex Second
```

Each window should remember its own ChatGPT account after quitting and reopening.

Do not put either profile directory in a repository or public sync folder. The setup isolates local profiles; it does not combine usage limits or billing.

## frequently asked questions

### Can I run two Codex accounts at the same time on one Mac?

Yes. Keep the installed Codex app for the primary account and launch a second
process with an isolated `CODEX_HOME` and Electron user-data directory.

### Why is `CODEX_HOME` alone not enough?

`CODEX_HOME` separates Codex configuration and authentication. The Electron
user-data directory separates desktop application state and prevents the
second launch from returning to the primary process.

### Do the two Codex profiles share chats, projects, or usage limits?

No. Each profile uses its own ChatGPT account and local application state.
This setup does not merge chats, projects, billing, or usage limits.

### Why does the Codex Second Dock icon disappear or turn blank?

Older Script Editor launchers can lose their Dock identity or invalidate their
signature after an icon change. The native launcher above embeds the icon
before signing and uses a stable bundle identifier.

### Does this modify the installed Codex app?

No. The normal Codex installation remains unchanged. The second launcher only
starts another isolated Codex process.

More: [OpenAI Codex guides](/topics/codex/).

---

Sources:

- [Codex Second native installer](/assets/scripts/install-codex-second.zsh)
- [Codex environment variables](https://learn.chatgpt.com/docs/config-file/environment-variables)
- [Codex configuration and state locations](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)
- [Codex authentication](https://learn.chatgpt.com/docs/auth)
