Personal fork of [aimen08/noty](https://github.com/aimen08/noty), updated to
the upstream 1.9.0 feature set.

- Sync notes through the iCloud Drive folder for editing on iPhone and iPad.
  Sync remains off by default; synced Markdown files are plaintext while the
  local database remains encrypted.
- Paste, drop, resize, export, and import inline images in note bodies.
- Continue and indent bullet, numbered, and task lists with Return and Tab.
- Keep the deck and notes on one Space instead of following every desktop.
- Choose any installed font from Settings. The selected face applies throughout
  the note, including its title, controls, tabs, previews, and library rows.
- Five themes: Follow macOS, Light, Dark, Sepia, and Nord. Theme changes apply
  immediately without replacing editor contents or interrupting Japanese IME.
- More robust persistence surfaces failed saves, retries before quitting, and
  preserves existing encrypted data when its key is missing or invalid.
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
