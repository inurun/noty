#!/bin/bash
# Build a native, updater-free app and a checksummed local Homebrew cask.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/build/homebrew"
VERSION="$(date +%Y.%m.%d.%H%M%S)"
ARCHIVE="$OUT/noty-local-$VERSION.zip"

if [ -d "$ROOT/Sparkle/Sparkle.framework" ]; then
    echo "Local Homebrew packages must be built without Sparkle. Move Sparkle/ out of this checkout first." >&2
    exit 1
fi
mkdir -p "$OUT" "$ROOT/build/module-cache"
BUILD_ARCHS="$(uname -m)" BUILD_NUMBER="$(date +%s)" \
    CLANG_MODULE_CACHE_PATH="$ROOT/build/module-cache" \
    SWIFT_MODULE_CACHE_PATH="$ROOT/build/module-cache" \
    "$ROOT/build.sh" release
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$ROOT/build/Noty.app" "$ARCHIVE"
python3 - "$ARCHIVE" "$VERSION" "$OUT/noty-local.rb" <<'PY'
import hashlib
import json
from pathlib import Path
import sys
archive, version, output = sys.argv[1:]
path = Path(archive)
checksum = hashlib.sha256(path.read_bytes()).hexdigest()
Path(output).write_text(f'''cask "noty-local" do
  version {json.dumps(version)}
  sha256 "{checksum}"

  url {json.dumps(path.as_uri())}
  name "Noty (Local Fork)"
  desc "Personal Noty build with custom fonts and themes"
  homepage "https://github.com/inurun/noty"

  depends_on macos: :sequoia
  app "Noty.app"
  uninstall quit: "app.noty.Noty"
end
''')
PY
printf 'Local package: %s\nCask: %s\n' "$ARCHIVE" "$OUT/noty-local.rb"
