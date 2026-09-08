#!/bin/bash
# Prepare a universal, updater-free archive and this repository's remote cask.
# This script does not publish anything. Run the Release workflow to publish.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VERSION="${1:-$(date -u +%Y.%m.%d.%H%M%S)}"
if [[ ! "$VERSION" =~ ^[0-9]{4}\.[0-9]{2}\.[0-9]{2}\.[0-9]{6}$ ]]; then
    echo "Version must be YYYY.MM.DD.HHMMSS (UTC)." >&2
    exit 1
fi
if [ -d "$ROOT/Sparkle/Sparkle.framework" ]; then
    echo "Remote fork releases must be built without Sparkle. Move Sparkle/ out first." >&2
    exit 1
fi
OUT="$ROOT/build/releases/$VERSION"
if [ -e "$OUT" ]; then
    echo "Release output already exists: $OUT. Use a new version." >&2
    exit 1
fi
mkdir -p "$OUT" "$ROOT/build/module-cache" "$ROOT/Casks"
BUILD_ARCHS="arm64 x86_64" BUILD_NUMBER="$(date +%s)" \
    MARKETING_VERSION="${MARKETING_VERSION:-1.6.1}" \
    CLANG_MODULE_CACHE_PATH="$ROOT/build/module-cache" \
    SWIFT_MODULE_CACHE_PATH="$ROOT/build/module-cache" \
    "$ROOT/build.sh" release
lipo "$ROOT/build/Noty.app/Contents/MacOS/Noty" -verify_arch arm64 x86_64
codesign --verify --deep --strict "$ROOT/build/Noty.app"
if otool -L "$ROOT/build/Noty.app/Contents/MacOS/Noty" | grep -q Sparkle; then
    echo "Unexpected Sparkle dependency." >&2
    exit 1
fi
ARCHIVE="$OUT/Noty-local-$VERSION-universal.zip"
ditto -c -k --sequesterRsrc --keepParent "$ROOT/build/Noty.app" "$ARCHIVE"
python3 - "$ARCHIVE" "$VERSION" "$ROOT/Casks/noty-local.rb" <<'PY'
import hashlib
from pathlib import Path
import sys
archive, version, output = sys.argv[1:]
checksum = hashlib.sha256(Path(archive).read_bytes()).hexdigest()
Path(output).write_text(f'''cask "noty-local" do
  version "{version}"
  sha256 "{checksum}"

  url "https://github.com/inurun/noty/releases/download/local-v#{{version}}/Noty-local-#{{version}}-universal.zip"
  name "Noty (Personal Fork)"
  desc "Sticky notes with custom fonts and five themes"
  homepage "https://github.com/inurun/noty"

  depends_on macos: :sequoia
  app "Noty.app"
  uninstall quit: "app.noty.Noty"
end
''')
PY
printf '%s\n' "$VERSION" > "$ROOT/build/release-version"
printf 'Prepared %s\nUpdated Casks/noty-local.rb\n' "$ARCHIVE"
