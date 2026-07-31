---
share: true
layout: post
title: "Run Two Codex Accounts on macOS"
date: 2026-07-26
published: true
filename: essay/_posts/2026-07-26-two-codex-accounts-two-dock-icons-macos
tags:
  - AI
  - Codex
  - macOS
  - tooling
  - productivity
excerpt: "Keep the installed Codex app for your primary account and add one isolated Codex Second launcher for another account."
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

## create one Dock launcher

Open Script Editor and paste:

```applescript
set homePath to system attribute "HOME"
set codexHome to "CODEX_HOME=" & homePath & "/.codex-work"
set appData to homePath & "/Library/Application Support/Codex Second"
set processPattern to "^/Applications/ChatGPT\\.app/Contents/MacOS/ChatGPT --user-data-dir=" & appData & "($| )"
set findProcess to "/usr/bin/pgrep -f " & quoted form of processPattern & " | /usr/bin/head -n 1 || true"
set secondPid to do shell script findProcess

if secondPid is "" then
  do shell script "/bin/mkdir -p " & quoted form of (homePath & "/.codex-work") & " " & quoted form of appData & " && /usr/bin/open -n -a Codex --env " & quoted form of codexHome & " --args " & quoted form of ("--user-data-dir=" & appData)

  repeat 20 times
    delay 0.25
    set secondPid to do shell script findProcess
    if secondPid is not "" then exit repeat
  end repeat
end if

if secondPid is not "" then
  tell application "System Events" to set frontmost of first application process whose unix id is (secondPid as integer) to true
end if
```

Choose **File → Save**, set **File Format** to **Application**, and save it as:

```text
~/Applications/Codex Second.app
```

The focus section matters. Clicking the pinned launcher will bring the isolated Codex window forward instead of making you click its temporary running-process icon.

macOS may ask whether `Codex Second` can control System Events. Allow it so the launcher can focus the correct window.

## optional: repair a blank or disappearing Dock icon

If `Codex Second` stays pinned with the correct icon, skip this step.

If its icon becomes blank or disappears from the Dock after a restart, the
launcher likely has no stable bundle identifier or its signature was
invalidated when the icon was pasted through Finder.

Embed the installed icon, give the launcher a stable bundle identifier, then
sign the completed launcher:

```zsh
launcher="$HOME/Applications/Codex Second.app"

cp /Applications/ChatGPT.app/Contents/Resources/icon-chatgpt.icns \
  "$launcher/Contents/Resources/applet.icns"

/usr/libexec/PlistBuddy \
  -c "Delete :CFBundleIdentifier" \
  "$launcher/Contents/Info.plist" 2>/dev/null || true

/usr/libexec/PlistBuddy \
  -c "Add :CFBundleIdentifier string com.edihasaj.codex-second" \
  "$launcher/Contents/Info.plist"

xattr -cr "$launcher"
codesign --force --deep --sign - \
  --identifier com.edihasaj.codex-second "$launcher"
codesign --verify --deep --strict --verbose=2 "$launcher"
```

Remove any older `Codex Second` Dock entry, then drag the repaired launcher from
`~/Applications` beside the normal Codex icon. Keep using the installed Codex
icon for your primary account.

The first launch after assigning the bundle identifier may ask again whether
`Codex Second` can control System Events. Allow it so the launcher can focus the
isolated window.

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

---

Sources:

- [Codex environment variables](https://learn.chatgpt.com/docs/config-file/environment-variables)
- [Codex configuration and state locations](https://learn.chatgpt.com/docs/config-file/config-advanced#config-and-state-locations)
- [Codex authentication](https://learn.chatgpt.com/docs/auth)
