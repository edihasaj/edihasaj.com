require 'jekyll'
require 'minitest/autorun'
require 'nokogiri'
require 'json'
require 'uri'
require_relative '../bin/generate-og'

ROOT_DIR = File.expand_path('..', __dir__)
SITE = Jekyll::Site.new(Jekyll.configuration('source' => ROOT_DIR, 'quiet' => true))
SITE.reset
SITE.read
SITE.generate

FIXTURES = {
  'override' => { 'og_image' => '/images/header-edi.jpg' },
  'opt-out' => { 'og_image' => false, 'image' => '/images/header-edi.jpg' },
  'fallback' => {},
  'visible-image' => { 'image' => '/images/header-edi.jpg' }
}.map do |name, data|
  page = Jekyll::PageWithoutAFile.new(SITE, SITE.source, 'fixtures', "#{name}.html")
  page.data.merge!('layout' => 'post', 'title' => 'A "quoted" title & more',
                   'description' => 'A "quoted" description & more', 'date' => Time.utc(2026, 9, 1))
  page.data.merge!(data)
  SITE.pages << page
  [name, page]
end.to_h
SITE.render

class SiteTest < Minitest::Test
  def html(page)
    Nokogiri::HTML(page.output)
  end

  def meta(doc, key)
    doc.at_css("meta[property='#{key}'], meta[name='#{key}']")&.[]('content')
  end

  def test_all_generated_cards_exist_and_match_metadata
    pages = SITE.pages + SITE.collections.values.flat_map(&:docs)
    SITE.data.fetch('og_images').each do |url, card|
      page = pages.find { |candidate| candidate.url == url }
      refute_nil page, url
      doc = html(page)
      expected = SITE.config['url'] + card.fetch('image')
      assert_equal expected, meta(doc, 'og:image'), url
      assert_equal expected, meta(doc, 'twitter:image'), url
      assert_equal 'summary_large_image', meta(doc, 'twitter:card'), url
      assert_equal card.fetch('title'), meta(doc, 'og:image:alt'), url
      png = File.binread(File.join(ROOT_DIR, card.fetch('image')))
      assert_equal "\x89PNG\r\n\x1a\n".b, png[0, 8], url
      assert_equal [1200, 630], png[16, 8].unpack('NN'), url
      assert_equal 1, doc.css('main').length, url
      assert_equal 1, doc.css('h1').length, url
      doc.css('script[type="application/ld+json"]').each do |script|
        schema = JSON.parse(script.text)
        assert_equal [expected], schema['image'], url if schema['@type'] == 'BlogPosting'
      end
    end
  end

  def test_image_override_opt_out_and_fallbacks
    portrait = SITE.config['url'] + '/images/header-edi.jpg'
    assert_equal portrait, meta(html(FIXTURES['override']), 'og:image')
    assert_equal portrait, meta(html(FIXTURES['visible-image']), 'og:image')
    fallback = SITE.config['url'] + SITE.data['og_images']['/']['image']
    assert_equal fallback, meta(html(FIXTURES['fallback']), 'og:image')
    opted_out = html(FIXTURES['opt-out'])
    assert_nil meta(opted_out, 'og:image')
    assert_nil meta(opted_out, 'twitter:image')
    assert_equal 'summary', meta(opted_out, 'twitter:card')
    schema = JSON.parse(opted_out.at_css('script[type="application/ld+json"]').text)
    refute schema.key?('image')
  end

  def test_metadata_escapes_titles_and_descriptions
    doc = html(FIXTURES['override'])
    assert_equal 'A "quoted" title & more', meta(doc, 'og:title')
    assert_equal 'A "quoted" description & more', meta(doc, 'description')
  end

  def test_home_and_archive_preserve_all_writing_links
    posts = SITE.posts.docs.select { |post| post.data['categories'].include?('posts') }
    archive = html(SITE.pages.find { |page| page.url == '/blog/' })
    links = archive.css('.writing-list a').map { |link| link['href'] }
    assert_equal posts.map(&:url).sort, links.sort
    assert archive.css('.writing-list a').all? { |link| !link.text.strip.empty? }
    home = html(SITE.pages.find { |page| page.url == '/' })
    home_links = home.css('.writing-list a').map { |link| link['href'] }
    assert_equal posts.map(&:url).sort, home_links.sort
    essays = posts.select { |post| post.data['writing_section'] == 'essays' }
    assert_equal essays.map(&:url).sort,
                 home.css('section[aria-labelledby="essays"] a').map { |link| link['href'] }.sort
  end

  def test_social_card_text_is_safe_and_fits_canvas
    svg = Nokogiri::XML(card_svg('A <tag> & "quote" ' + 'W' * 120))
    assert_empty svg.errors
    svg.css('text').each do |line|
      assert_operator line['y'].to_f, :>, 60
      assert_operator line['y'].to_f, :<, 600
      assert_operator line.text.length, :<=, 28
    end
  end

  def test_development_files_are_not_published
    paths = SITE.static_files.map(&:relative_path)
    refute paths.any? { |path| path.match?(%r{/(node_modules|tests|bin)/|\.test\.js$}) }
  end

  def test_author_sits_above_readable_page_titles
    SITE.data.fetch('og_images').each do |url, card|
      svg = Nokogiri::XML(card_svg(card['title'], home: url == '/'))
      author = svg.at_css('.card-author')
      assert_equal 'Edi Hasaj', author.text
      svg.css('.card-title').each do |line|
        assert_operator line['y'].to_f, :>, author['y'].to_f + 50
        assert_operator line['font-size'].to_f, :>=, 48
        assert_operator line['font-size'].to_f, :<, author['font-size'].to_f
      end
    end
  end
end
