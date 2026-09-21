cask "noty-local" do
  version "2026.09.21.072853"
  sha256 "0682acbfe6ad3530a5ee1af9610c535090c61d59e9d22ee0e844dcfcae6ec76a"

  url "https://github.com/inurun/noty/releases/download/local-v#{version}/Noty-local-#{version}-universal.zip"
  name "Noty (Personal Fork)"
  desc "Sticky notes with custom fonts and five themes"
  homepage "https://github.com/inurun/noty"

  depends_on macos: :sequoia
  app "Noty.app"
  uninstall quit: "app.noty.Noty"
end
