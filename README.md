# hanzpo/homebrew-tap

Homebrew tap for hanzpo tools.

## kalshi-cli releases

The `kalshi-cli bottles` workflow keeps `Formula/kalshi-cli.rb` in sync with
the latest `hanzpo/kalshi-cli` GitHub release and builds bottles on the
GitHub-hosted Apple Silicon macOS runners available to this repository.

Normal release flow:

1. Publish a tagged `hanzpo/kalshi-cli` release, for example `v0.1.3`.
2. Wait for the scheduled `kalshi-cli bottles` workflow, or run it manually from
   the Actions tab with `version` set to `0.1.3`.
3. The workflow updates the formula, builds bottles, uploads bottle assets to a
   `kalshi-cli-<version>` release in this tap, merges the bottle block, and
   pushes the tap commits.

Use the `force` input to rebuild bottles for the formula's current version.

Intel macOS bottles are not part of the default matrix because GitHub's Intel
macOS runners currently report unbottled build dependencies for this Rust
formula. Add a self-hosted Intel runner or accept source fallback for Intel
users.
