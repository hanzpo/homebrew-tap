cask "swiftspot" do
  version "1.0.1"
  sha256 "a1f78712f83919b3ff8feec7b4aaa6ece22aec75edd639cf6ee1064fc766a7bc"

  url "https://github.com/hanzpo/swiftspot/releases/download/v#{version}/SwiftSpot-#{version}.zip"
  name "SwiftSpot"
  desc "Native Spotify client"
  homepage "https://github.com/hanzpo/swiftspot"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "SwiftSpot.app"

  zap trash: [
    "~/Library/Application Support/com.hanzpo.swiftspot",
    "~/Library/Caches/com.hanzpo.swiftspot",
  ]
end
