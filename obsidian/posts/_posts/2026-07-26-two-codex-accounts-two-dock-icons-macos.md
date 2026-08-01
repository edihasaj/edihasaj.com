---
share: true
layout: post
title: "How to Run Two Codex Accounts on macOS with Separate Profiles"
date: 2026-07-26
last_modified_at: 2026-08-01
published: true
filename: essay/_posts/2026-07-26-two-codex-accounts-two-dock-icons-macos
tags:
  - AI
  - Codex
  - macOS
  - tooling
  - productivity
excerpt: "Run two Codex accounts on one Mac with isolated profiles, one clean Dock icon, background multitasking, and fast account switching."
faq:
  - question: "Can I run two Codex accounts at the same time on one Mac?"
    answer: "Yes. Run the signed app twice, giving the second process an isolated CODEX_HOME and Electron user-data directory."
  - question: "Why is CODEX_HOME alone not enough?"
    answer: "CODEX_HOME separates Codex configuration and authentication. A separate Electron user-data directory prevents the second desktop launch from returning to the primary process."
  - question: "Can both Codex accounts keep working while I switch windows?"
    answer: "Yes. The switcher opens or focuses a profile without quitting the other process. Both remain active until you explicitly quit one, although sleep or an application crash can still interrupt local work."
  - question: "Why should I keep only one Codex Dock icon?"
    answer: "Both processes use the same signed OpenAI bundle identity. Pinning custom wrappers creates duplicate or mismatched running-app tiles, so the reliable layout is one official Dock pin plus a menu-bar account switcher."
  - question: "Does this modify or re-sign the installed Codex app?"
    answer: "No. The signed OpenAI app remains unchanged. Only the small local controller and background launchers are compiled and ad-hoc signed."
  - question: "Is running two desktop instances guaranteed to be crash-free?"
    answer: "No. The profiles are isolated, but this is still a local multi-instance workaround rather than an official in-app account switcher."
---

> **Update, August 1, 2026:** The original version used two pinned wrapper apps.
> That looked tidy until macOS created extra running-app tiles and Spotlight found
> old launcher copies. The improved setup keeps one official Dock icon and uses
> a menu-bar controller to open or focus either isolated account.

The result is practical multitasking without modifying the signed Codex app:

- `Option-Command-1` opens or focuses Primary;
- `Option-Command-2` opens or focuses Secondary;
- switching focus does not quit the other process;
- **Open Both** starts both profiles;
- **Quit Primary** and **Quit Secondary** stop them explicitly;
- Applications and Spotlight contain only the current controller and launchers.

## How the two profiles are isolated

| Profile state | Primary | Secondary |
| --- | --- | --- |
| Codex configuration and authentication | `~/.codex` | `~/.codex-work` |
| Desktop application data | normal app data | `~/Library/Application Support/Codex Second` |

`CODEX_HOME` isolates Codex configuration and authentication. The separate
`--user-data-dir` is also required because the desktop app uses Electron and
otherwise hands a second launch back to the first process.

## Test the secondary account

Run this in Terminal before installing the switcher:

```zsh
codex_app="/Applications/ChatGPT.app"
[[ -d "$codex_app" ]] || codex_app="$HOME/Applications/ChatGPT.app"

mkdir -p "$HOME/.codex-work"
mkdir -p "$HOME/Library/Application Support/Codex Second"

open -n "$codex_app" \
  --env "CODEX_HOME=$HOME/.codex-work" \
  --args "--user-data-dir=$HOME/Library/Application Support/Codex Second"
```

A second Codex window should open. Sign into the other ChatGPT account once;
later launches reuse that profile's isolated authentication and desktop state.

## Install the account switcher

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

- leaves `/Applications/ChatGPT.app` unchanged and preserves its signature;
- installs `~/Applications/Codex Account Switcher.app` as a login item;
- installs background launchers named `Codex Primary`, `Codex Secondary`, and
  `Codex Open Both` in `~/Applications`;
- keeps exactly one official ChatGPT/Codex Dock pin;
- removes stale launcher pins that cause duplicate running-app tiles;
- moves replaced launchers to the Trash so they remain recoverable.

The three Applications launchers signal the menu controller and immediately
exit. Because they are background agents, they do not create their own Dock
tiles. They are useful from Finder, Launchpad, Raycast, or Spotlight.

## Multitask without stopping background work

After installation, choose **Open Both** or open the two profile launchers.
Both desktop processes remain alive. `Option-Command-1` and
`Option-Command-2` only change focus; they do not terminate either account.

That means a local task can continue in the background while you work in the
other account. Keep the Mac awake and leave both processes open. A Codex crash,
manual quit, restart, or system sleep can still interrupt local work.

When you want to reduce memory use or avoid running two instances, use
**Quit Primary** or **Quit Secondary** from the menu-bar controller.

## Keep the Dock clean

Pin only the installed OpenAI app. Do not pin `Codex Primary`,
`Codex Secondary`, or `Codex Open Both`.

Both Codex processes share the same signed bundle identity. Depending on the
macOS version and current Dock state, macOS may group them under the official
tile or temporarily show another running tile. Pinning wrapper apps cannot
reliably force two permanent identities and is what causes the confusing
duplicate-icon behavior.

## Verify both accounts

Choose **Open Both**, then run:

```zsh
pgrep -alf "ChatGPT.app/Contents/MacOS/ChatGPT"
```

You should see two main processes. The secondary process includes:

```text
--user-data-dir=/Users/you/Library/Application Support/Codex Second
```

Each window should remember its own account after quitting and reopening. Do
not place either profile directory in a repository or public sync folder. This
setup isolates local profiles; it does not merge chats, projects, billing, or
usage limits.

## Frequently asked questions

### Can I run two Codex accounts at the same time on one Mac?

Yes. The signed app runs twice, while the second process uses an isolated
`CODEX_HOME` and Electron user-data directory.

### Why is `CODEX_HOME` alone not enough?

It separates Codex configuration and authentication, but not all Electron
desktop state. The separate user-data directory allows the second desktop
process to start independently.

### Can both accounts keep working while I switch windows?

Yes. The switcher opens or focuses the requested profile and leaves the other
one running. Use the explicit Quit menu items when you want to stop one.

### Why not pin two custom Codex launchers?

The launchers and real running app have different identities, while both real
Codex processes share OpenAI's bundle identity. macOS therefore cannot map two
custom permanent pins cleanly to the two processes.

### Does this modify the installed Codex app?

No. The official bundle is neither edited nor re-signed. The installer only
builds and signs the small local controller and its background launchers.

### Is this guaranteed to be crash-free?

No. Separate profile directories prevent state collisions, but simultaneous
desktop instances remain a local workaround. Use one process when maximum
stability matters.

More: [OpenAI Codex guides](/topics/codex/).

---

Sources:

- [Codex account-switcher installer](/assets/scripts/install-codex-second.zsh)
- [Codex environment variables](https://learn.chatgpt.com/docs/config-file/environment-variables)
- [Codex configuration and state locations](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)
- [Codex authentication](https://learn.chatgpt.com/docs/auth)
