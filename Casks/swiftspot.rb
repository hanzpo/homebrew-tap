cask "swiftspot" do
  version "1.0.0"
  sha256 "dcba28a5da12f499c5fae3fd980b4bc94b390ab96a3cb0877b5fbaeef90fc59d"

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
