# Preserve previously published mixed-case tag links.
module Jekyll
  class TagAliases < Generator
    safe true
    priority :high

    def generate(site)
      tags = site.posts.docs.flat_map { |post| Array(post.data['tags']) }.uniq
      tags.each do |tag|
        slug = Jekyll::Utils.slugify(tag)
        next if tag == slug || !tag.match?(/\A[A-Za-z0-9_-]+\z/)

        page = PageWithoutAFile.new(site, site.source, "tag/#{tag}", 'index.html')
        page.data.merge!('layout' => nil, 'sitemap' => false,
                         'redirect_to' => "/tag/#{slug}")
        site.pages << page
      end
    end
  end
end
