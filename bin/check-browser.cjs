#!/usr/bin/env node
// Run after starting bin/serve. Uses the shared abx browser session.
const { execFileSync } = require('child_process');
const path = require('path');
const root = path.resolve(__dirname, '..');
const base = process.argv[2] || 'http://127.0.0.1:4010';
const run = (...args) => execFileSync('abx', args, { encoding: 'utf8', timeout: 30000 }).trim();
const routes = JSON.parse(execFileSync('bundle', ['exec', 'ruby', '-ryaml', '-rjson', '-e',
  'puts YAML.load_file("_data/og_images.yml").keys.to_json'], { cwd: root, encoding: 'utf8' }));
const results = [];
for (const [size, dark] of [['1280x900', false], ['390x844', false], ['320x740', true]]) {
  run('viewport', size);
  run('goto', base);
  run('js', `if (document.documentElement.classList.contains('theme-dark') !== ${dark}) document.querySelector('.theme-toggle').click()`);
  for (const route of routes) {
    const navigation = run('goto', base + route);
    const result = JSON.parse(run('js', `JSON.stringify({
      route: location.pathname,
      overflow: document.documentElement.scrollWidth > innerWidth,
      h1: document.querySelectorAll('h1').length,
      main: document.querySelectorAll('main').length,
      dark: document.documentElement.classList.contains('theme-dark'),
      brokenImages: [...document.images].filter(i => i.complete && i.naturalWidth === 0).map(i => i.src),
      emptyLinks: [...document.querySelectorAll('main a')].filter(a => !a.textContent.trim() && !a.querySelector('img')).map(a => a.href),
      og: document.querySelector('meta[property="og:image"]')?.content
    })`));
    results.push({ size, expectedDark: dark, navigation, ...result });
  }
}
const failed = results.filter(r => !r.navigation.includes('(200)') || r.overflow || r.h1 !== 1 ||
  r.main !== 1 || r.dark !== r.expectedDark || r.brokenImages.length || r.emptyLinks.length || !r.og);
console.log(JSON.stringify({ checked: results.length, failed }, null, 2));
process.exitCode = failed.length ? 1 : 0;
