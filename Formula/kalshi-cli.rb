class KalshiCli < Formula
  desc "CLI for the Kalshi prediction market API"
  homepage "https://github.com/hanzpo/kalshi-cli"
  url "https://github.com/hanzpo/kalshi-cli/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "619b4e079258160ac5b03e057ef8ab0cebed1e810c690731ad58a6c4571e889c"
  license "MIT"

  bottle do
    root_url "https://github.com/hanzpo/homebrew-tap/releases/download/kalshi-cli-0.1.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a442685e9a05e89b038bec54bcc9756ae3296c3c79567756b2813300f69669d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5966419e80ce31df3fe98f5769512eb6c04d062d26e3de22e818adc4c5a5859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6e8d64c257fdc11eebe636be5df9504bb39258c19a9b0a4fa0151463718f89"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalshi --version")
  end
end
