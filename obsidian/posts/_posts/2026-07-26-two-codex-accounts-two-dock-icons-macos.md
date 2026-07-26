---
share: true
layout: post
title: "Two Codex Accounts, Two Dock Icons on macOS"
date: 2026-07-26
published: false
filename: essay/_posts/2026-07-26-two-codex-accounts-two-dock-icons-macos
tags:
  - AI
  - Codex
  - macOS
  - tooling
  - productivity
excerpt: "A separate CODEX_HOME isolates Codex state, but it is not enough to run two desktop instances at once. Here is the complete macOS setup, including the Electron data directory and two permanent Dock launchers."
---

I use two ChatGPT accounts with Codex. One is my primary account. The other is a separate account I want ready when I need it, without logging out, signing in again, and reversing the whole process later.

The obvious macOS command gets halfway there:

```zsh
mkdir -p "$HOME/.codex-work"
open -n -a Codex --env "CODEX_HOME=$HOME/.codex-work"
```

`CODEX_HOME` gives the second process its own Codex state. OpenAI documents it as the root for configuration, authentication, logs, sessions, skills, and other local data. The normal profile stays in `~/.codex`; the second one lives in `~/.codex-work`.

But on the current Codex desktop app, that command alone did not give me two running app processes. I tested it on both my MacBook and Mac Studio. macOS accepted the command, but Electron still pointed both launches at the same desktop data directory:

```text
~/Library/Application Support/Codex
```

That directory owns Electron's single-instance lock. The second launch handed control back to the first app.

The complete setup needs two layers of isolation:

| Layer | Primary account | Second account |
| --- | --- | --- |
| Codex state | `~/.codex` | `~/.codex-work` |
| Desktop data | `~/Library/Application Support/Codex` | `~/Library/Application Support/Codex Second` |

Here is the working command:

```zsh
mkdir -p "$HOME/.codex-work"
mkdir -p "$HOME/Library/Application Support/Codex Second"

open -n -a Codex \
  --env "CODEX_HOME=$HOME/.codex-work" \
  --args "--user-data-dir=$HOME/Library/Application Support/Codex Second"
```

`-n` asks macOS to start another application instance. `CODEX_HOME` separates Codex's own state. `--user-data-dir` separates the Electron shell and lets both desktop processes stay alive.

This is the part worth keeping. `CODEX_HOME` and `--user-data-dir` solve different problems.

## turn them into two Dock apps

I do not want to remember a terminal command every time I switch accounts. I want two permanent icons:

- Codex Primary
- Codex Second

The cleanest built-in option is Script Editor. It ships with macOS and can save a tiny AppleScript as an application.

Open Script Editor and create the primary launcher:

```applescript
do shell script "/usr/bin/open -a Codex"
```

Save it as an application:

```text
~/Applications/Codex Primary.app
```

Create a second Script Editor document with:

```applescript
set homePath to system attribute "HOME"
set codexHome to "CODEX_HOME=" & homePath & "/.codex-work"
set appData to homePath & "/Library/Application Support/Codex Second"

do shell script "/bin/mkdir -p " & quoted form of (homePath & "/.codex-work") & " " & quoted form of appData & " && /usr/bin/open -n -a Codex --env " & quoted form of codexHome & " --args " & quoted form of ("--user-data-dir=" & appData)
```

Save that one as:

```text
~/Applications/Codex Second.app
```

Open `~/Applications` in Finder, then drag both launchers into the Dock.

The first icon opens the normal Codex profile. The second opens a simultaneous, isolated instance. Sign into the second ChatGPT account once. Later launches reuse its local account state.

## use the real Codex icon

Script Editor gives launcher apps a generic script icon. If you want both Dock entries to look like Codex:

1. Select the installed Codex app in Finder and press `Command-I`.
2. Click the icon at the top of the Info window and press `Command-C`.
3. Open Get Info for each launcher.
4. Select its icon and press `Command-V`.

The names still distinguish the two entries when you hover over them. You can also give the second launcher a custom badge if you want the difference visible at a glance.

## verify that isolation is real

Launch both Dock entries, then run:

```zsh
pgrep -alf "ChatGPT.app/Contents/MacOS/ChatGPT"
```

The exact executable path can vary by release, but you should see two main processes. The second should include something like:

```text
--user-data-dir=/Users/you/Library/Application Support/Codex Second
```

Then check the profile menu in each window. The primary window should show account A. The second window should show account B. Quit the second instance, reopen `Codex Second`, and confirm it remembers account B.

If the second launcher only focuses the first window, check three things:

1. `-n` is present.
2. `CODEX_HOME` points to the same second directory every time.
3. `--user-data-dir` is present and points somewhere different from the primary app data.

The third check is the one most instructions miss.

## what this does, and what it does not

This setup isolates local profiles. It does not combine usage limits, transfer quota, or change which account is billed. Every Codex request still belongs to the ChatGPT account signed into that window.

It is also not an official multi-account switcher. `CODEX_HOME` is a documented Codex environment variable, but the two-launcher desktop workflow is a macOS and Electron workaround I verified against the current app. A future Codex release could change its desktop process model.

Treat both profile directories as sensitive:

```text
~/.codex-work
~/Library/Application Support/Codex Second
```

Do not put them in a project repository or public sync folder. Do not copy their credentials to another machine. Create the directories on the other Mac and sign in there normally.

The result is pleasantly boring. Two Dock icons. Two accounts. No repeated logout dance.

---

Sources:

- [Codex environment variables](https://learn.chatgpt.com/docs/config-file/environment-variables)
- [Codex configuration and state locations](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)
- [Codex authentication](https://learn.chatgpt.com/docs/auth)
