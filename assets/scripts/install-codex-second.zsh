#!/bin/zsh

set -euo pipefail

destination="${CODEX_SECOND_APP_PATH:-$HOME/Applications/Codex Second.app}"
primary_destination="${CODEX_PRIMARY_APP_PATH:-$HOME/Applications/Codex Primary.app}"
bundle_identifier="com.edihasaj.codex-second"
primary_bundle_identifier="com.edihasaj.codex-primary"
install_primary=false

case "${1:-}" in
  "") ;;
  --with-primary) install_primary=true ;;
  *)
    print -u2 "Usage: ${0:t} [--with-primary]"
    exit 2
    ;;
esac

if [[ -d /Applications/ChatGPT.app ]]; then
  chatgpt_app="/Applications/ChatGPT.app"
elif [[ -d "$HOME/Applications/ChatGPT.app" ]]; then
  chatgpt_app="$HOME/Applications/ChatGPT.app"
else
  print -u2 "Codex is not installed in /Applications or ~/Applications."
  exit 1
fi

if [[ ! -x /usr/bin/swiftc ]]; then
  print -u2 "Swift is unavailable. Run: xcode-select --install"
  exit 1
fi

icon="$chatgpt_app/Contents/Resources/icon-chatgpt.icns"
if [[ ! -f "$icon" ]]; then
  print -u2 "Codex icon not found at: $icon"
  exit 1
fi

build_directory="$(mktemp -d "${TMPDIR%/}/codex-second.XXXXXX")"
staged_app="$build_directory/Codex Second.app"

cleanup() {
  [[ ! -d "$build_directory" ]] || rm -rf -- "$build_directory"
}
trap cleanup EXIT HUP INT TERM

mkdir -p "$staged_app/Contents/MacOS" "$staged_app/Contents/Resources"

cat > "$build_directory/main.swift" <<'SWIFT'
import AppKit
import Foundation

let home = FileManager.default.homeDirectoryForCurrentUser.path
let codexHome = "\(home)/.codex-work"
let appData = "\(home)/Library/Application Support/Codex Second"
let executableCandidates = [
    "/Applications/ChatGPT.app/Contents/MacOS/ChatGPT",
    "\(home)/Applications/ChatGPT.app/Contents/MacOS/ChatGPT",
]

guard let chatGPTExecutable = executableCandidates.first(
    where: { FileManager.default.isExecutableFile(atPath: $0) }
) else {
    fatalError("The installed Codex executable could not be found.")
}

let chatGPTApp = URL(fileURLWithPath: chatGPTExecutable)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .path

func run(_ executable: String, arguments: [String]) throws -> (Int32, String) {
    let process = Process()
    let output = Pipe()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    process.standardOutput = output
    process.standardError = FileHandle.nullDevice
    try process.run()
    process.waitUntilExit()
    let data = output.fileHandleForReading.readDataToEndOfFile()
    return (process.terminationStatus, String(decoding: data, as: UTF8.self))
}

func secondProcessID() -> pid_t? {
    let executable = NSRegularExpression.escapedPattern(for: chatGPTExecutable)
    let dataDirectory = NSRegularExpression.escapedPattern(for: appData)
    let pattern = "^\(executable) --user-data-dir=\(dataDirectory)($| )"

    guard let result = try? run("/usr/bin/pgrep", arguments: ["-f", pattern]),
          result.0 == 0,
          let firstLine = result.1.split(separator: "\n").first,
          let pid = pid_t(firstLine)
    else {
        return nil
    }

    return pid
}

func showFailure(_ message: String) {
    NSApplication.shared.setActivationPolicy(.accessory)
    NSApplication.shared.activate(ignoringOtherApps: true)
    let alert = NSAlert()
    alert.messageText = "Codex Second could not open"
    alert.informativeText = message
    alert.alertStyle = .warning
    alert.runModal()
}

do {
    try FileManager.default.createDirectory(
        atPath: codexHome,
        withIntermediateDirectories: true
    )
    try FileManager.default.createDirectory(
        atPath: appData,
        withIntermediateDirectories: true
    )

    var pid = secondProcessID()
    if pid == nil {
        let result = try run(
            "/usr/bin/open",
            arguments: [
                "-n",
                chatGPTApp,
                "--env", "CODEX_HOME=\(codexHome)",
                "--args", "--user-data-dir=\(appData)",
            ]
        )
        guard result.0 == 0 else {
            showFailure("The installed Codex app could not be launched.")
            exit(1)
        }

        for _ in 0..<20 {
            Thread.sleep(forTimeInterval: 0.25)
            pid = secondProcessID()
            if pid != nil {
                break
            }
        }
    }

    guard let pid else {
        showFailure("The isolated Codex process did not start.")
        exit(1)
    }

    if let application = NSRunningApplication(processIdentifier: pid) {
        application.activate(options: [.activateAllWindows])
    }
} catch {
    showFailure(error.localizedDescription)
    exit(1)
}
SWIFT

cat > "$staged_app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleDisplayName</key>
  <string>Codex Second</string>
  <key>CFBundleExecutable</key>
  <string>CodexSecond</string>
  <key>CFBundleIconFile</key>
  <string>CodexSecond.icns</string>
  <key>CFBundleIdentifier</key>
  <string>com.edihasaj.codex-second</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Codex Second</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>2.0</string>
  <key>CFBundleVersion</key>
  <string>3</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

/usr/bin/swiftc -O "$build_directory/main.swift" \
  -o "$staged_app/Contents/MacOS/CodexSecond"
cp "$icon" "$staged_app/Contents/Resources/CodexSecond.icns"

xattr -cr "$staged_app"
codesign --force --deep --sign - \
  --identifier "$bundle_identifier" "$staged_app"
codesign --verify --deep --strict "$staged_app"

mkdir -p "${destination:h}"

if [[ -e "$destination" ]]; then
  backup_name="Codex Second old $(date +%Y%m%d-%H%M%S)-$$.app"
  if [[ "$destination" == "$HOME/Applications/Codex Second.app" ]]; then
    mv "$destination" "$HOME/.Trash/$backup_name"
    print "Previous launcher moved to ~/.Trash/$backup_name"
  else
    mv "$destination" "${destination}.old-$(date +%Y%m%d-%H%M%S)-$$"
  fi
fi

mv "$staged_app" "$destination"
touch "$destination"

print "Installed: $destination"
print "Bundle ID: $bundle_identifier"

if $install_primary; then
  primary_staged_app="$build_directory/Codex Primary.app"
  mkdir -p \
    "$primary_staged_app/Contents/MacOS" \
    "$primary_staged_app/Contents/Resources"

  cat > "$build_directory/primary.swift" <<'SWIFT'
import AppKit
import Foundation

let home = FileManager.default.homeDirectoryForCurrentUser.path
let codexHome = "\(home)/.codex"
let executableCandidates = [
    "/Applications/ChatGPT.app/Contents/MacOS/ChatGPT",
    "\(home)/Applications/ChatGPT.app/Contents/MacOS/ChatGPT",
]

guard let chatGPTExecutable = executableCandidates.first(
    where: { FileManager.default.isExecutableFile(atPath: $0) }
) else {
    fatalError("The installed Codex executable could not be found.")
}

let chatGPTApp = URL(fileURLWithPath: chatGPTExecutable)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .path

func run(_ executable: String, arguments: [String]) throws -> (Int32, String) {
    let process = Process()
    let output = Pipe()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    process.standardOutput = output
    process.standardError = FileHandle.nullDevice
    try process.run()
    process.waitUntilExit()
    let data = output.fileHandleForReading.readDataToEndOfFile()
    return (process.terminationStatus, String(decoding: data, as: UTF8.self))
}

func primaryProcessID() -> pid_t? {
    let executable = NSRegularExpression.escapedPattern(for: chatGPTExecutable)
    let pattern = "^\(executable)$"

    guard let result = try? run("/usr/bin/pgrep", arguments: ["-f", pattern]),
          result.0 == 0,
          let firstLine = result.1.split(separator: "\n").first,
          let pid = pid_t(firstLine)
    else {
        return nil
    }

    return pid
}

func showFailure(_ message: String) {
    NSApplication.shared.setActivationPolicy(.accessory)
    NSApplication.shared.activate(ignoringOtherApps: true)
    let alert = NSAlert()
    alert.messageText = "Codex Primary could not open"
    alert.informativeText = message
    alert.alertStyle = .warning
    alert.runModal()
}

do {
    try FileManager.default.createDirectory(
        atPath: codexHome,
        withIntermediateDirectories: true
    )

    var pid = primaryProcessID()
    if pid == nil {
        let result = try run(
            "/usr/bin/open",
            arguments: [
                "-n",
                chatGPTApp,
                "--env", "CODEX_HOME=\(codexHome)",
            ]
        )
        guard result.0 == 0 else {
            showFailure("The installed Codex app could not be launched.")
            exit(1)
        }

        for _ in 0..<20 {
            Thread.sleep(forTimeInterval: 0.25)
            pid = primaryProcessID()
            if pid != nil {
                break
            }
        }
    }

    guard let pid else {
        showFailure("The primary Codex process did not start.")
        exit(1)
    }

    if let application = NSRunningApplication(processIdentifier: pid) {
        application.activate(options: [.activateAllWindows])
    }
} catch {
    showFailure(error.localizedDescription)
    exit(1)
}
SWIFT

  cat > "$primary_staged_app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleDisplayName</key>
  <string>Codex Primary</string>
  <key>CFBundleExecutable</key>
  <string>CodexPrimary</string>
  <key>CFBundleIconFile</key>
  <string>CodexPrimary.icns</string>
  <key>CFBundleIdentifier</key>
  <string>com.edihasaj.codex-primary</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Codex Primary</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>2.0</string>
  <key>CFBundleVersion</key>
  <string>3</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

  /usr/bin/swiftc -O "$build_directory/primary.swift" \
    -o "$primary_staged_app/Contents/MacOS/CodexPrimary"
  cp "$icon" "$primary_staged_app/Contents/Resources/CodexPrimary.icns"

  xattr -cr "$primary_staged_app"
  codesign --force --deep --sign - \
    --identifier "$primary_bundle_identifier" "$primary_staged_app"
  codesign --verify --deep --strict "$primary_staged_app"

  mkdir -p "${primary_destination:h}"

  if [[ -e "$primary_destination" ]]; then
    backup_name="Codex Primary old $(date +%Y%m%d-%H%M%S)-$$.app"
    if [[ "$primary_destination" == "$HOME/Applications/Codex Primary.app" ]]; then
      mv "$primary_destination" "$HOME/.Trash/$backup_name"
      print "Previous launcher moved to ~/.Trash/$backup_name"
    else
      mv "$primary_destination" \
        "${primary_destination}.old-$(date +%Y%m%d-%H%M%S)-$$"
    fi
  fi

  mv "$primary_staged_app" "$primary_destination"
  touch "$primary_destination"

  print "Installed: $primary_destination"
  print "Bundle ID: $primary_bundle_identifier"
  print "Next: replace old Codex Dock entries with Codex Primary and Codex Second from ~/Applications."
else
  print "Next: remove any old Dock entry, then drag Codex Second from ~/Applications to the Dock."
fi
