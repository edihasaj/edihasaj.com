require 'jekyll'
require 'minitest/autorun'
require 'tmpdir'
require_relative '../bin/generate-og'

class SocialCardsTest < Minitest::Test
  def with_site
    Dir.mktmpdir('social-cards-test') do |root|
      FileUtils.mkdir_p(File.join(root, '_posts'))
      File.write(File.join(root, 'index.html'), "---\nlayout: default\ntitle: Home\n---\nHello")
      yield root
    end
  end

  def site_at(root)
    site = Jekyll::Site.new(Jekyll.configuration('source' => root, 'quiet' => true,
                                                'title' => 'Edi Hasaj', 'description' => 'Software, AI and Thinking.'))
    site.reset
    site.read
    site
  end

  def post(root, title: 'A new post', content: 'First draft', extra: '')
    File.write(File.join(root, '_posts/2020-01-01-new-post.md'),
               "---\nlayout: post\ntitle: #{title}\n#{extra}---\n#{content}")
  end

  def test_cold_build_new_post_content_edit_and_title_edit
    with_site do |root|
      first = generate_social_cards(site_at(root))
      assert_equal({ generated: 1, reused: 0, total: 1 }, first)
      files = Dir[File.join(root, 'images/og/*.png')]
      mtimes = files.to_h { |file| [file, File.mtime(file)] }
      assert_equal 0, generate_social_cards(site_at(root))[:generated]
      assert_equal mtimes, files.to_h { |file| [file, File.mtime(file)] }

      post(root)
      assert_equal({ generated: 1, reused: 1, total: 2 }, generate_social_cards(site_at(root)))
      original = YAML.load_file(File.join(root, '_data/og_images.yml'))
      post(root, content: 'Changed body, same social card')
      assert_equal 0, generate_social_cards(site_at(root))[:generated]
      post(root, title: 'An updated title')
      assert_equal({ generated: 1, reused: 1, total: 2 }, generate_social_cards(site_at(root)))
      updated = YAML.load_file(File.join(root, '_data/og_images.yml'))
      refute_equal original, updated
      assert_equal original['/'], updated['/']
      assert_equal 2, generate_social_cards(site_at(root), force: true)[:generated]
      assert_equal 0, generate_social_cards(site_at(root), check: true)[:generated]
    end
  end

  def test_new_unpublished_posts_and_explicit_opt_out_do_not_generate_cards
    with_site do |root|
      post(root, extra: "published: false\n")
      assert_equal 1, generate_social_cards(site_at(root))[:total]
      post(root, extra: "og_image: false\n")
      assert_equal 1, generate_social_cards(site_at(root))[:total]
    end
  end

  def test_layout_and_font_changes_invalidate_the_card
    svg = card_svg('A title')
    original = social_card_image('/post', svg, 'font-v1')
    assert_equal original, social_card_image('/post', svg, 'font-v1')
    refute_equal original, social_card_image('/post', svg.sub('#f0eee6', '#ffffff'), 'font-v1')
    refute_equal original, social_card_image('/post', svg, 'font-v2')
  end

  def test_missing_cached_image_is_regenerated
    with_site do |root|
      generate_social_cards(site_at(root))
      card = Dir[File.join(root, 'images/og/*.png')].first
      FileUtils.mv(card, "#{card}.missing")
      assert_raises(RuntimeError) { generate_social_cards(site_at(root), check: true) }
      assert_equal 1, generate_social_cards(site_at(root))[:generated]
      assert File.file?(card)
    end
  end
end
