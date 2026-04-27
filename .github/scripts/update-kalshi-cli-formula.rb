#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "fileutils"
require "json"
require "net/http"
require "uri"

FORMULA = ENV.fetch("FORMULA", "Formula/kalshi-cli.rb")
REPO = ENV.fetch("UPSTREAM_REPO", "hanzpo/kalshi-cli")
VERSION_INPUT = ENV.fetch("VERSION", "").strip
FORCE = ENV.fetch("FORCE", "false") == "true"
OUTPUT = ENV["GITHUB_OUTPUT"]

def request(uri, token: nil, limit: 10)
  raise "too many redirects while fetching #{uri}" if limit.zero?

  req = Net::HTTP::Get.new(uri)
  req["Accept"] = "application/vnd.github+json"
  req["Authorization"] = "Bearer #{token}" if token && !token.empty?
  req["User-Agent"] = "homebrew-tap-release-bot"

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
    res = http.request(req)
    case res
    when Net::HTTPRedirection
      request(URI(res["location"]), token: token, limit: limit - 1)
    when Net::HTTPSuccess
      res.body
    else
      raise "GET #{uri} failed: #{res.code} #{res.message}\n#{res.body}"
    end
  end
end

def latest_tag(repo, token)
  body = request(URI("https://api.github.com/repos/#{repo}/releases/latest"), token: token)
  JSON.parse(body).fetch("tag_name")
end

def write_output(values)
  return unless OUTPUT

  File.open(OUTPUT, "a") do |file|
    values.each { |key, value| file.puts("#{key}=#{value}") }
  end
end

token = ENV["GITHUB_TOKEN"]
tag = VERSION_INPUT.empty? ? latest_tag(REPO, token) : VERSION_INPUT
tag = "v#{tag}" unless tag.start_with?("v")
version = tag.delete_prefix("v")
source_url = "https://github.com/#{REPO}/archive/refs/tags/#{tag}.tar.gz"
root_url = "https://github.com/hanzpo/homebrew-tap/releases/download/kalshi-cli-#{version}"

formula = File.read(FORMULA)
current_version = formula[%r{archive/refs/tags/v?([^/]+)\.tar\.gz}, 1]

write_output(
  "current_version" => current_version,
  "root_url" => root_url,
  "tag" => tag,
  "version" => version,
)

if current_version == version && !FORCE
  write_output("changed" => "false")
  puts "kalshi-cli is already at #{version}; nothing to do."
  exit 0
end

tarball = request(URI(source_url), token: token)
sha256 = Digest::SHA256.hexdigest(tarball)

updated = formula
  .sub(%r{url "https://github\.com/#{Regexp.escape(REPO)}/archive/refs/tags/v?[^/]+\.tar\.gz"},
       %(url "#{source_url}"))
  .sub(/sha256 "[0-9a-f]{64}"/, %(sha256 "#{sha256}"))
  .gsub(/\n  bottle do\n(?:    .*\n)+  end\n/, "\n")

if updated == formula
  if FORCE
    write_output(
      "changed" => "false",
      "sha256" => sha256,
    )
    puts "kalshi-cli formula is already prepared for #{version}; rebuilding bottles."
    exit 0
  end

  raise "formula did not change; check #{FORMULA}"
end

File.write(FORMULA, updated)

write_output(
  "changed" => "true",
  "sha256" => sha256,
)

puts "updated kalshi-cli formula from #{current_version || "unknown"} to #{version}"
