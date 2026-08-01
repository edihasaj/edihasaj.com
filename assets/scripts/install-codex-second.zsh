#!/bin/zsh

set -euo pipefail

asset_base="${CODEX_SWITCHER_ASSET_BASE:-https://edihasaj.com/assets/scripts/codex-account-switcher}"
source_override="${CODEX_SWITCHER_SOURCE_DIR:-}"
destination="$HOME/Applications/Codex Account Switcher.app"
launch_agent="$HOME/Library/LaunchAgents/com.edihasaj.codex-account-switcher.plist"
label="com.edihasaj.codex-account-switcher"
lsregister_bin="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

if [[ -x /Applications/ChatGPT.app/Contents/MacOS/ChatGPT ]]; then
  codex_app="/Applications/ChatGPT.app"
elif [[ -x "$HOME/Applications/ChatGPT.app/Contents/MacOS/ChatGPT" ]]; then
  codex_app="$HOME/Applications/ChatGPT.app"
else
  print -u2 "The signed ChatGPT/Codex app was not found."
  exit 1
fi

if ! xcrun --find swiftc >/dev/null 2>&1; then
  print -u2 "Swift is unavailable. Run: xcode-select --install"
  exit 1
fi

codex_app_url="file://$codex_app/"
codex_icon="$codex_app/Contents/Resources/icon-chatgpt.icns"
[[ -f "$codex_icon" ]] || codex_icon="$codex_app/Contents/Resources/app.icns"
build_root="$(mktemp -d "${TMPDIR%/}/codex-account-switcher.XXXXXX")"
source_root="$build_root/sources"
staged_app="$build_root/Codex Account Switcher.app"

cleanup() {
  [[ "$build_root" == "${TMPDIR%/}/codex-account-switcher."* ]] || return
  [[ ! -d "$build_root" ]] || /bin/rm -rf -- "$build_root"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$source_root"
source_files=(
  CodexAccountSwitcher.swift
  CodexLauncher.swift
  Info.plist
  Launcher-Info.plist
  com.edihasaj.codex-account-switcher.plist
)
for source_file in "${source_files[@]}"; do
  if [[ -n "$source_override" ]]; then
    cp "$source_override/$source_file" "$source_root/$source_file"
  else
    curl --proto '=https' --tlsv1.2 -fsSL \
      "$asset_base/$source_file" -o "$source_root/$source_file"
  fi
done

plutil -lint \
  "$source_root/Info.plist" \
  "$source_root/Launcher-Info.plist" \
  "$source_root/com.edihasaj.codex-account-switcher.plist" >/dev/null

mkdir -p "$staged_app/Contents/MacOS"
xcrun swiftc -O -framework AppKit -framework Carbon \
  "$source_root/CodexAccountSwitcher.swift" \
  -o "$staged_app/Contents/MacOS/CodexAccountSwitcher"
cp "$source_root/Info.plist" "$staged_app/Contents/Info.plist"
xattr -cr "$staged_app"
codesign --force --sign - "$staged_app"
codesign --verify --deep --strict "$staged_app"

xcrun swiftc -O -framework AppKit \
  "$source_root/CodexLauncher.swift" \
  -o "$build_root/CodexLauncher"

stage_launcher() {
  local display_name="$1"
  local bundle_identifier="$2"
  local action="$3"
  local launcher_app="$build_root/$display_name.app"

  mkdir -p "$launcher_app/Contents/MacOS" "$launcher_app/Contents/Resources"
  cp "$build_root/CodexLauncher" "$launcher_app/Contents/MacOS/CodexLauncher"
  sed \
    -e "s|__DISPLAY_NAME__|$display_name|g" \
    -e "s|__BUNDLE_IDENTIFIER__|$bundle_identifier|g" \
    -e "s|__ACTION__|$action|g" \
    "$source_root/Launcher-Info.plist" > "$launcher_app/Contents/Info.plist"
  cp "$codex_icon" "$launcher_app/Contents/Resources/AppIcon.icns"
  xattr -cr "$launcher_app"
  codesign --force --sign - "$launcher_app"
  codesign --verify --deep --strict "$launcher_app"
}

stage_launcher "Codex Primary" "com.edihasaj.codex-primary-launcher" primary
stage_launcher "Codex Secondary" "com.edihasaj.codex-secondary-launcher" secondary
stage_launcher "Codex Open Both" "com.edihasaj.codex-open-both-launcher" both

move_existing_to_trash() {
  local target="$1"
  [[ -e "$target" ]] || return 0
  local base_name="${target:t:r}"
  local extension="${target:e}"
  local trash_target="$HOME/.Trash/$base_name old $(date +%Y%m%d-%H%M%S)-$$.$extension"
  "$lsregister_bin" -u "$target" 2>/dev/null || true
  mkdir -p "$HOME/.Trash"
  mv "$target" "$trash_target"
  print "Previous app moved to: $trash_target"
}

launchctl bootout "gui/$UID/$label" 2>/dev/null || true
move_existing_to_trash "$destination"
mkdir -p "$HOME/Applications" "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
mv "$staged_app" "$destination"

for launcher_name in "Codex Primary" "Codex Secondary" "Codex Open Both"; do
  launcher_destination="$HOME/Applications/$launcher_name.app"
  move_existing_to_trash "$launcher_destination"
  mv "$build_root/$launcher_name.app" "$launcher_destination"
done
move_existing_to_trash "$HOME/Applications/Codex Second.app"

sed "s|__HOME__|$HOME|g" \
  "$source_root/com.edihasaj.codex-account-switcher.plist" \
  > "$build_root/launch-agent.plist"
plutil -lint "$build_root/launch-agent.plist" >/dev/null
cp "$build_root/launch-agent.plist" "$launch_agent"

dock_plist="$build_root/dock.plist"
defaults export com.apple.dock "$dock_plist" >/dev/null
removed=0
changed=0
chatgpt_kept=0
for index in {100..0}; do
  label_value=$(plutil -extract \
    "persistent-apps.$index.tile-data.file-label" raw -o - \
    "$dock_plist" 2>/dev/null) || continue
  url_value=$(plutil -extract \
    "persistent-apps.$index.tile-data.file-data._CFURLString" raw -o - \
    "$dock_plist" 2>/dev/null || true)

  case "$label_value" in
    ChatGPT)
      if [[ "$url_value" == "$codex_app_url" ]] && (( chatgpt_kept == 0 )); then
        chatgpt_kept=1
      else
        plutil -remove "persistent-apps.$index" "$dock_plist"
        ((removed += 1))
        changed=1
      fi
      ;;
    'Codex Primary'|'Codex Second'|'Codex Secondary'|'Codex Open Both')
      plutil -remove "persistent-apps.$index" "$dock_plist"
      ((removed += 1))
      changed=1
      ;;
  esac
done

if (( chatgpt_kept == 0 )); then
  next_index=0
  for index in {0..100}; do
    if plutil -extract "persistent-apps.$index" xml1 -o /dev/null \
      "$dock_plist" 2>/dev/null; then
      next_index=$((index + 1))
    fi
  done
  dock_entry='{"tile-data":{"file-data":{"_CFURLString":"'"$codex_app_url"'","_CFURLStringType":15},"file-label":"ChatGPT","file-type":41},"tile-type":"file-tile"}'
  plutil -insert "persistent-apps.$next_index" \
    -json "$dock_entry" "$dock_plist"
  changed=1
fi

if (( changed > 0 )); then
  defaults import com.apple.dock "$dock_plist"
  killall Dock
fi

launchctl bootstrap "gui/$UID" "$launch_agent"
launchctl kickstart -k "gui/$UID/$label"

current_apps=(
  "$codex_app"
  "$destination"
  "$HOME/Applications/Codex Primary.app"
  "$HOME/Applications/Codex Secondary.app"
  "$HOME/Applications/Codex Open Both.app"
)
for current_app in "${current_apps[@]}"; do
  "$lsregister_bin" -f "$current_app"
done
"$lsregister_bin" -gc

print "Installed menu controller: $destination"
print "Applications: Codex Primary, Codex Secondary, Codex Open Both"
print "Official Dock pin: $codex_app"
print "Removed duplicate/launcher Dock pins: $removed"
print "Open/focus Primary: Option-Command-1"
print "Open/focus Secondary: Option-Command-2"
print "Both profiles remain running until explicitly quit."
