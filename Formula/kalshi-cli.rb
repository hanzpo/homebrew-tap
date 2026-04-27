class KalshiCli < Formula
  desc "CLI for the Kalshi prediction market API"
  homepage "https://github.com/hanzpo/kalshi-cli"
  url "https://github.com/hanzpo/kalshi-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "619b4e079258160ac5b03e057ef8ab0cebed1e810c690731ad58a6c4571e889c"
  license "MIT"


  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalshi --version")
  end
end
