Personal fork of [aimen08/noty](https://github.com/aimen08/noty).

- Choose any installed font using the macOS font panel.
- Five themes: Follow macOS, Light, Dark, Sepia, and Nord.
- Appearance changes apply to open notes and previews.
- Universal app for Apple Silicon and Intel, macOS 15 or later.
- No Sparkle updater. Updates are managed through Homebrew.

Install:

```sh
brew tap inurun/noty https://github.com/inurun/noty.git
brew install --cask inurun/noty/noty-local
```

Quit any existing Noty before installation. This fork uses the same notes and
preferences as the original and should not run alongside it. If Noty was
installed manually, move the app to Trash first, keeping its data.

The app is ad-hoc signed and not notarized. macOS may require you to allow its
first launch in System Settings → Privacy & Security.

Update with `brew update` and `brew upgrade --cask noty-local`.
