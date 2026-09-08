#!/bin/bash
# Install or update the published personal fork. Does not build local changes.
set -euo pipefail
export HOMEBREW_NO_ANALYTICS=1
CASK="inurun/noty/noty-local"
INSTALLED_TAP="$(brew info --json=v2 --cask --installed | python3 -c 'import json,sys; print(next((c["tap"] for c in json.load(sys.stdin)["casks"] if c["token"] == "noty-local"), ""))')"
if [ -n "$INSTALLED_TAP" ] && [ "$INSTALLED_TAP" != "inurun/noty" ]; then
    echo "Quit Noty, then run: brew uninstall --cask $INSTALLED_TAP/noty-local (notes/settings are kept)." >&2
    echo "If the old tap contains no other packages, untap it before rerunning this script." >&2
    exit 1
elif [ -z "$INSTALLED_TAP" ] && [ -e /Applications/Noty.app ]; then
    echo "Quit Noty and move /Applications/Noty.app to Trash first. Keep your notes and settings." >&2
    exit 1
fi
brew tap inurun/noty https://github.com/inurun/noty.git
if [ -n "$INSTALLED_TAP" ]; then
    brew update
    brew upgrade --cask "$CASK"
else
    brew install --cask "$CASK"
fi
printf '\nInstalled %s. Open /Applications/Noty.app to use it.\n' "$CASK"
