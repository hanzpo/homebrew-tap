class KalshiCli < Formula
    desc "CLI for the Kalshi prediction market API"
    homepage "https://github.com/hanzpo/kalshi-cli"
    url "https://github.com/hanzpo/kalshi-cli/archive/refs/tags/v0.1.1.tar.gz"
    sha256 "ad06ad1a153cf2d71a2a0e0f5d27c245497824dc8d6ee6380bd45d4fcdb8efbe"
    license "MIT"

    depends_on "rust" => :build

    def install
      system "cargo", "install", *std_cargo_args(path: ".")
    end

    test do
      assert_match version.to_s, shell_output("#{bin}/kalshi --version")
    end
  end
