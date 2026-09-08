#!/bin/bash
# Install or update the published personal fork. Does not build local changes.
set -euo pipefail
export HOMEBREW_NO_ANALYTICS=1
CASK="inurun/noty/noty-local"
if brew list --cask noty-local >/dev/null 2>&1; then
    INSTALLED_TAP="$(brew info --json=v2 --cask noty-local | python3 -c 'import json,sys; print(json.load(sys.stdin)["casks"][0]["tap"])')"
    if [ "$INSTALLED_TAP" != "inurun/noty" ]; then
        echo "Quit Noty, then run: brew uninstall --cask noty-local (notes/settings are kept). Rerun this script afterward." >&2
        exit 1
    fi
elif [ -e /Applications/Noty.app ]; then
    echo "Quit Noty and move /Applications/Noty.app to Trash first. Keep your notes and settings." >&2
    exit 1
fi
brew tap inurun/noty https://github.com/inurun/noty.git
if brew list --cask noty-local >/dev/null 2>&1; then
    brew update
    brew upgrade --cask "$CASK"
else
    brew install --cask "$CASK"
fi
printf '\nInstalled %s. Open /Applications/Noty.app to use it.\n' "$CASK"
