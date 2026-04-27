class KalshiCli < Formula
  desc "CLI for the Kalshi prediction market API"
  homepage "https://github.com/hanzpo/kalshi-cli"
  url "https://github.com/hanzpo/kalshi-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "619b4e079258160ac5b03e057ef8ab0cebed1e810c690731ad58a6c4571e889c"
  license "MIT"

  bottle do
    root_url "https://github.com/hanzpo/homebrew-tap/releases/download/kalshi-cli-0.1.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "3709adfba304fa0e307c236d020835e90427dd9f3febb7ef7901fc5fce8a8e57"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalshi --version")
  end
end
