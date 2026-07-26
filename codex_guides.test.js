const fs = require("fs");
const path = require("path");

const root = __dirname;
const guidesSource = path.join(root, "_codex_guides");
const guidesOutput = path.join(root, "_site", "guides", "codex");

function read(file) {
  return fs.readFileSync(file, "utf8");
}

function sourceSlugs() {
  return fs
    .readdirSync(guidesSource)
    .filter((file) => file.endsWith(".md"))
    .map((file) => path.basename(file, ".md"))
    .sort();
}

describe("Codex programmatic guide collection", () => {
  test("publishes every source guide at its canonical route", () => {
    const slugs = sourceSlugs();

    expect(slugs).toHaveLength(10);

    for (const slug of slugs) {
      const output = path.join(guidesOutput, slug, "index.html");
      const html = read(output);
      const canonical = `https://edihasaj.com/guides/codex/${slug}/`;

      expect(fs.existsSync(output)).toBe(true);
      expect(html).toContain(`<link rel='canonical' href="${canonical}">`);
      expect(html).toContain('"@type": "TechArticle"');
      expect(html).toContain('"@type": "BreadcrumbList"');
      expect(html).toContain("Related Codex guides");
      expect(html).not.toMatch(/noindex/i);
    }
  });

  test("indexes the hub and every guide in discovery surfaces", () => {
    const sitemap = read(path.join(root, "_site", "sitemap.xml"));
    const llms = read(path.join(root, "_site", "llms.txt"));
    const hub = read(path.join(guidesOutput, "index.html"));

    expect(sitemap).toContain(
      "<loc>https://edihasaj.com/guides/codex/</loc>"
    );

    for (const slug of sourceSlugs()) {
      const url = `https://edihasaj.com/guides/codex/${slug}/`;

      expect(sitemap).toContain(`<loc>${url}</loc>`);
      expect(llms).toContain(url);
      expect(hub).toContain(`href="/guides/codex/${slug}/"`);
    }
  });

  test("keeps search intents and descriptions unique", () => {
    const sources = sourceSlugs().map((slug) =>
      read(path.join(guidesSource, `${slug}.md`))
    );
    const intents = sources.map(
      (source) => source.match(/^intent: "(.+)"$/m)?.[1]
    );
    const descriptions = sources.map(
      (source) => source.match(/^description: "(.+)"$/m)?.[1]
    );

    expect(intents.every(Boolean)).toBe(true);
    expect(descriptions.every(Boolean)).toBe(true);
    expect(new Set(intents).size).toBe(sources.length);
    expect(new Set(descriptions).size).toBe(sources.length);
  });
});
