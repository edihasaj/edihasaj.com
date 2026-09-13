# Edi Hasaj

## Development

1. `bundle install`
2. `bundle exec jekyll serve`

For testing Obsidian's obsidian-github-publisher's regex,
run `bin/test-obsidian-regex`. See `obsidian_regex_publisher.test.js` for more
details.

## Apps / projects list (single source)

The apps shown on `/about/` **and** in the profile README
(`../edihasaj/README.md`) both come from `_data/projects.yml`.

To add or edit an app:

1. Edit `_data/projects.yml` (sections: `open_source`, `projects`, `legacy`).
2. Run `node bin/gen-readme.js` to sync the profile README.
3. Commit both repos.

Hosted private products omit the optional `source` field.

`node bin/gen-readme.js --check` fails if the README has drifted (CI-friendly).

## Organization

## SEO and crawler discovery

Public posts are exposed through multiple machine-readable surfaces:

- `/sitemap.xml` lists canonical pages, posts, topic hubs, and guides.
- `/robots.txt` allows normal search crawlers and major AI/search crawlers, and points to the sitemap.
- `/agents.txt` states the public agent policy for search, citation, summarization, and agentic reading.
- `/llms.txt` gives LLMs a concise site index with core pages, topic hubs, and current posts.
- `/atom.xml` remains the primary RSS/Atom feed.

Post and topic pages also emit JSON-LD structured data from `_includes/seo-jsonld.html`.
When adding a new recurring subject area, create a topic page under `_pages/topics/`
with `layout: topic` and matching `topic_tags` so it appears in the sitemap and
LLM index.

## Theme

The site uses a narrow reading column, Newsreader, and a warm paper palette, inspired
by darioamodei.com. `_sass/_editorial.scss` defines the layout.
`_sass/_fonts.scss` loads self-hosted Newsreader at optical size 24, with variable
weights 400–700 in roman and italic. Font files come from Google Fonts; their
SIL Open Font License is in `assets/fonts/newsreader/OFL.txt`.
The homepage opens with a short third-person introduction, followed by Essays
and Notes & guides. The full biography lives on About.
Set `writing_section: essays` in front matter for an essay. Other posts
appear in Notes & guides. The complete archive remains at `/blog/`.

The palette matches the reference: paper `#f0eee6`, ink `#1f1e1d`, with the
colours reversed in dark mode. Articles use a 580px reading column and larger
headings. An optional `subtitle` appears below the article title.

Articles with at least two H2 headings get a generated table of contents through
`js/toc.js`. On screens at least 1200px wide it sits fixed to the left and opens
by default. Readers can close and reopen it without moving the article; desktop
preferences persist. Smaller screens get an inline, initially closed control.
Links preserve native fragment navigation, show the current section while
scrolling, and support keyboard focus. Escape closes the panel. Without
JavaScript, the article stays readable and the empty control stays hidden.
Light mode is the default; the header toggle persists dark mode in local storage.
`js/app.js` handles the toggle without a JavaScript library. All writing remains
readable with JavaScript disabled. Lists show titles and dates; images stay inside
articles. Keep new styles on the `--theme-*` tokens.

### Posts

To create a new post, you can create a new markdown file inside the `_posts`
directory by following the
[recommended file structure](https://jekyllrb.com/docs/posts/#creating-post-files).

The following is a post file with different configurations you can add as an
example:

```sh
---
layout: post
title: Title of the Post
featured: true
tags: [tag-one, tag-two]
image: '/images/welcome.jpg'
og_image: '/images/social-card.jpg'
---
```

Every titled page and post gets a generated 1200 × 630 PNG card on warm paper.
“Edi Hasaj” appears above the page title in large Newsreader type. The title below
uses a prominent 60px size, reduced only for long titles. The homepage uses the
site description beneath the name. Run `bundle exec ruby bin/generate-og.rb` after adding a page or
changing a title. Commit `images/og/` and `_data/og_images.yml` with the content.
GitHub Pages serves the committed images; it needs no custom plugin or image API.

Generation requires `rsvg-convert` (Homebrew: `brew install librsvg`). The SVG
uses the bundled Newsreader TTF through an isolated Fontconfig file, so rendering
does not depend on installed system fonts. To change card
design, bump `VERSION` in the generator; image URLs then change for cache refresh.
`--check` detects missing cards or changed titles; `--force` rerenders existing cards.

`image` remains the visible article image. `og_image` overrides the generated
social card; `og_image: false` suppresses social images. Pages without a generated
card fall back to their visible image, then the site's name card. Open Graph,
Twitter, and JSON-LD share this selection through `_includes/social-image.liquid`.
Run `bin/check` before publishing.

To keep things more organized, add post images to **/images/posts** directory,
and add page images to **/images/pages** directory.

To create a draft post, create the post file under the `_drafts` directory.

For tags, try to not add space between two words, for example, `Ruby on
Rails`, could be something like (`ruby-on-rails`, `Ruby_on_Rails`, or
`Ruby-on-Rails`).

### Pages

To create a new page, just create a new markdown file inside the `_pages` directory.

The following is the `about.md` file that you can find as an example included in the theme with the configurations you can set.

```sh
---
layout: page
title: About
image: '/images/pages/about.jpeg'
---
```

Things you can change are: `title` and `image` path.


### Navigation

The header links to Writing and About. The homepage lists recent posts and topic
hubs. Footer links provide social profiles and RSS.

### Known Problems

Note that tags are not working with GitHub Pages, that's because the used
[jekyll-tagging ](https://github.com/pattex/jekyll-tagging) plugin is not
[whitelisted](https://pages.github.com/versions/) by GitHub.  To make this work,
use [Netlify.com](https://www.netlify.com/) for deployment.

## Browser verification

Start `bundle exec jekyll serve --port 4010`, then run
`node bin/check-browser.cjs`. It checks every generated-card page at desktop,
mobile, and narrow mobile widths, including persisted dark mode, overflow,
headings, broken images, and empty links. Pass a base URL to check another server.
The script uses the shared `abx` session and changes its viewport and theme.
Run `node bin/check-reader.cjs` to exercise the contents panel, keyboard controls,
section navigation, saved state, and light/dark palette. It also accepts a base URL.

The old theme partials, jQuery, FitVids, and icon runtime have been removed.
Responsive video sizing now lives in CSS. `landing` uses the default layout.
