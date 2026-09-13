#!/usr/bin/env ruby
# Generate static social cards before publishing to GitHub Pages.
require 'jekyll'
require 'digest'
require 'cgi'
require 'fileutils'
require 'open3'
require 'tempfile'
require 'json'

ROOT = File.expand_path('..', __dir__)

# Conservative line lengths leave room for wide serif glyphs.
def title_lines(title)
  words = title.split.flat_map { |word| word.scan(/.{1,28}/) }
  words.each_with_object([]) do |word, lines|
    if !lines.empty? && lines.last.length + word.length + 1 <= 28
      lines[-1] += " #{word}"
    else
      lines << word
    end
  end
end

def card_svg(title, home: false, description: 'Software, AI and Thinking.')
  lines = title_lines(home ? description : title)
  size = [60, (260.0 / [lines.length, 1].max / 1.18).floor].min
  line_height = size * 1.18
  # Bottom-align the whole text block, leaving unused space above it.
  first_y = 530 - (lines.length - 1) * line_height
  author_y = first_y - 110
  text = lines.each_with_index.map do |line, index|
    %(<text class="card-title" x="88" y="#{first_y + index * line_height}" font-size="#{size}">#{CGI.escapeHTML(line)}</text>)
  end.join
  <<~SVG
    <svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
      <rect width="1200" height="630" fill="#f0eee6"/>
      <g font-family="Newsreader 24pt" fill="#1f1e1d">
        <text class="card-author" x="88" y="#{author_y}" font-size="104">Edi Hasaj</text>
        #{text}
      </g>
    </svg>
  SVG
end

# An isolated Fontconfig file makes rendering use the bundled font on every host.
def with_card_font
  Tempfile.create(['edi-og-fonts', '.conf']) do |config|
    config.write(%(<?xml version="1.0"?><!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd"><fontconfig><dir>#{CGI.escapeHTML(File.join(ROOT, 'assets/fonts/newsreader'))}</dir></fontconfig>))
    config.flush
    yield({ 'FONTCONFIG_FILE' => config.path })
  end
end

# The cache key covers the actual rendered card and the bundled font, so layout
# and font changes cannot silently reuse old pixels.
def social_card_image(url, svg, font_digest)
  digest = Digest::SHA256.hexdigest([url, svg, font_digest].join("\n"))[0, 20]
  "/images/og/#{digest}.png"
end

def generate_social_cards(site, force: false, check: false)
  font_digest = Digest::SHA256.file(File.join(ROOT, 'assets/fonts/newsreader/newsreader-24pt-regular.ttf')).hexdigest
  entries = (site.pages + site.collections.values.flat_map(&:docs)).select do |page|
    %w[default page post topic landing].include?(page.data['layout']) && page.data['title'] && page.data['og_image'] != false
  end
  svgs = {}
  cards = entries.to_h do |page|
    title = page.url == '/' ? site.config['title'] : page.data['title'].to_s
    svg = card_svg(title, home: page.url == '/', description: site.config['description'])
    svgs[page.url] = svg
    [page.url, { 'title' => title, 'image' => social_card_image(page.url, svg, font_digest) }]
  end.sort.to_h
  manifest = "# Generated automatically by bin/build. Do not edit.\n" + cards.to_yaml
  manifest_path = File.join(site.source, '_data/og_images.yml')
  output_path = ->(card) { File.join(site.source, card.fetch('image')) }
  if check
    missing = cards.values.reject { |card| File.file?(output_path.call(card)) }
    raise 'Social cards are stale. Run bin/build.' unless File.exist?(manifest_path) && File.read(manifest_path) == manifest && missing.empty?
    return { generated: 0, reused: cards.length, total: cards.length }
  end

  generated = 0
  FileUtils.mkdir_p(File.join(site.source, 'images/og'))
  FileUtils.mkdir_p(File.dirname(manifest_path))
  with_card_font do |font_env|
    cards.each do |url, card|
      output = output_path.call(card)
      next if File.exist?(output) && !force
      Tempfile.create(['edi-og', '.svg']) do |file|
        file.write(svgs.fetch(url))
        file.flush
        # Only put complete PNGs into the reusable cache.
        Tempfile.create(['edi-og', '.png'], File.dirname(output)) do |png|
          _, error, status = Open3.capture3(font_env, 'rsvg-convert', '--output', png.path, file.path)
          raise "Social card failed: #{error}" unless status.success?
          FileUtils.cp(png.path, output)
        end
      end
      generated += 1
    end
  end
  File.write(manifest_path, manifest) unless File.exist?(manifest_path) && File.read(manifest_path) == manifest
  { generated: generated, reused: cards.length - generated, total: cards.length }
end

if $PROGRAM_NAME == __FILE__
  Dir.chdir(ROOT) do
    site = Jekyll::Site.new(Jekyll.configuration('quiet' => true))
    site.reset
    site.read
    stats = generate_social_cards(site, force: ARGV.include?('--force'), check: ARGV.include?('--check'))
    puts "Social cards: #{stats[:generated]} generated, #{stats[:reused]} reused (#{stats[:total]} total)."
    if ENV['GITHUB_STEP_SUMMARY']
      File.open(ENV.fetch('GITHUB_STEP_SUMMARY'), 'a') { |file| file.puts("Social cards: #{stats.to_json}") }
    end
  end
end
