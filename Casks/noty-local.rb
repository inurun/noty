cask "noty-local" do
  version "2026.09.08.092008"
  sha256 "27642f4db56e260f788daacc61f33c2c84c6129b87f8a6957bc7ba66c8eb7a6b"

  url "https://github.com/inurun/noty/releases/download/local-v#{version}/Noty-local-#{version}-universal.zip"
  name "Noty (Personal Fork)"
  desc "Sticky notes with custom fonts and five themes"
  homepage "https://github.com/inurun/noty"

  depends_on macos: :sequoia
  app "Noty.app"
  uninstall quit: "app.noty.Noty"
end
