# Vision

`edihasaj.com` is the personal blog and portfolio of Edi Hasaj — writing on software, AI, and thinking, plus an apps/projects list. It is a static site built with Jekyll 4 (kramdown Markdown, Sass, Liquid templating), authored primarily in Markdown and published from an Obsidian-based workflow, with light/dark theming and machine-readable SEO surfaces (sitemap, RSS/Atom, `robots.txt`, `agents.txt`, `llms.txt`, JSON-LD). The guiding constraint: fast, content-first, and durable — a static site with no framework bloat, where content and discoverability come first.

## In Scope

- Blog posts (`posts/_posts/`, Markdown + front matter), drafts (`_drafts`), and guides collection.
- Topic hub pages (`_pages/topics/`, `layout: topic` with `topic_tags`) and standard pages (`_pages/`).
- Apps/projects list sourced from `_data/projects.yml`, synced to the profile README via `bin/gen-readme.js`.
- Site UX: layouts (`_layouts/`), includes (`_includes/`), navigation, header/footer, light/dark theme toggle.
- Styling via Sass partials (`_sass/`) using `var(--theme-*)` CSS variables for both themes.
- Performance: static output, compressed Sass, minimal JS (`js/app.js`).
- SEO / crawler discovery: `sitemap.xml`, `atom.xml`/`feed.xml`, `robots.txt`, `agents.txt`, `llms.txt`, `_includes/seo-jsonld.html`.
- Accessibility and readability across light and dark modes.
- Build tooling: Jekyll build/serve (`bundle`, `bin/serve`, `bin/setup`), `_config.yml`, redirects (`jekyll-redirect-from`).
- The Obsidian publisher regex tooling and its test (`obsidian_regex_publisher.test.js`, `bin/test-obsidian-regex`).

## Out of Scope

- Backend services, databases, or server-side application code (site is fully static).
- Non-static frameworks (Next/Astro/React app rewrites) or swapping the static-site generator.
- Third-party account/dashboard config (Disqus account, analytics provider setup, social profiles).
- Content in other repos except the generated profile README sync target.
- Paid/gated content, auth, or user accounts.

## Merge by Default

- Typo, grammar, formatting, and factual-link fixes in existing posts and pages.
- Styling, layout, and Sass fixes; theme-token (`var(--theme-*)`) corrections for light/dark parity.
- Performance improvements (asset optimization, image compression, reducing JS, Sass cleanup).
- Accessibility fixes (alt text, contrast, semantic markup, focus states).
- SEO/metadata upkeep: sitemap, feed, JSON-LD, `robots.txt`, `agents.txt`, `llms.txt` corrections.
- Scaffolding new posts (empty/draft front matter, file naming, image folders) without authoring opinions.
- Editing `_data/projects.yml` for accurate project metadata and re-running `bin/gen-readme.js` to keep README in sync (`--check` passes).
- Dependency bumps in `Gemfile` / npm devDeps that keep the build green and tests passing (`jest`).
- Build/config fixes that keep `jekyll build` and local serve working.

## Needs Sign-Off

- Publishing NEW written content or opinions under Edi's name (blog posts, guides, "about" copy, project descriptions carrying a point of view).
- Marking a post `published: true` / promoting a draft to live.
- Visual redesigns, new layouts, or brand/typography changes.
- Domain, `CNAME`, or deploy/hosting changes (Netlify vs GitHub Pages, plugin whitelist implications).
- Adding or changing analytics/tracking, comments provider, or any third-party scripts.
- Changing the public agent/crawler policy (`agents.txt`, `robots.txt` allow/deny rules).
- Adding new plugins or major structural changes to `_config.yml` (permalinks, collections, pagination).

## Roadmap

### Short-term
- Keep SEO surfaces (sitemap, `llms.txt`, `agents.txt`, JSON-LD) consistent as posts and topics are added.
- Ensure `_data/projects.yml` and the generated profile README stay in sync (`gen-readme.js --check`).
- Verify light/dark theme parity for any new surfaces via `var(--theme-*)` tokens.
- Address the known GitHub Pages / `jekyll-tagging` whitelist limitation via the Netlify deploy path.

### Long-term
- Grow the writing catalog across the core topic hubs (AI agents, MCP, open source, security, software).
- Strengthen static-site performance and Core Web Vitals without adding framework bloat.
- Improve machine-readability for AI/search crawlers as citation and agentic-reading conventions evolve.
- Streamline the Obsidian-to-Jekyll publishing pipeline and its regex tooling.
