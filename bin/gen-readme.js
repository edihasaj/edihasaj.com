#!/usr/bin/env node
// Sync the apps/projects catalog from _data/projects.yml into the profile
// README at ../edihasaj/README.md. Replaces everything between the
// <!-- APPS:START --> and <!-- APPS:END --> markers.
//
// Usage: node bin/gen-readme.js [--check]
//   --check  exit 1 if the README is out of date (for CI), write nothing.

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const YAML_PATH = path.join(ROOT, '_data', 'projects.yml');
const README_PATH = path.resolve(ROOT, '..', 'edihasaj', 'README.md');
const START = '<!-- APPS:START -->';
const END = '<!-- APPS:END -->';

// Minimal YAML reader for our flat list-of-maps shape. Avoids adding a dep.
function parseProjects(text) {
  const data = {};
  let section = null;
  let cur = null;
  for (const raw of text.split('\n')) {
    const line = raw.replace(/\s+$/, '');
    if (!line || line.trimStart().startsWith('#')) continue;
    const sec = line.match(/^([a-z_]+):\s*$/);
    if (sec) {
      section = sec[1];
      data[section] = [];
      cur = null;
      continue;
    }
    const item = line.match(/^  - (\w+):\s*(.*)$/);
    if (item) {
      cur = {};
      data[section].push(cur);
      cur[item[1]] = unquote(item[2]);
      continue;
    }
    const field = line.match(/^    (\w+):\s*(.*)$/);
    if (field && cur) cur[field[1]] = unquote(field[2]);
  }
  return data;
}

function unquote(v) {
  const t = v.trim();
  if ((t.startsWith('"') && t.endsWith('"')) || (t.startsWith("'") && t.endsWith("'"))) {
    return t.slice(1, -1);
  }
  return t;
}

function renderList(items) {
  return items
    .map((p) => {
      const src = p.source ? ` ([source](${p.source}))` : '';
      return `- ${p.emoji} **[${p.name}](${p.url})** - ${p.desc}${src}`;
    })
    .join('\n');
}

function buildBlock(data) {
  return [
    '## Open Source',
    '',
    renderList(data.open_source || []),
    '',
    '## Projects',
    '',
    renderList(data.projects || []),
    '',
    '### Legacy',
    '',
    renderList(data.legacy || []),
  ].join('\n');
}

function main() {
  const check = process.argv.includes('--check');
  const data = parseProjects(fs.readFileSync(YAML_PATH, 'utf8'));
  const block = buildBlock(data);

  const readme = fs.readFileSync(README_PATH, 'utf8');
  const s = readme.indexOf(START);
  const e = readme.indexOf(END);
  if (s === -1 || e === -1 || e < s) {
    console.error(`Markers ${START} / ${END} not found in ${README_PATH}`);
    process.exit(2);
  }

  const next =
    readme.slice(0, s + START.length) + '\n\n' + block + '\n\n' + readme.slice(e);

  if (next === readme) {
    console.log('README already up to date.');
    return;
  }
  if (check) {
    console.error('README is out of date. Run: node bin/gen-readme.js');
    process.exit(1);
  }
  fs.writeFileSync(README_PATH, next);
  console.log(`Updated ${README_PATH}`);
}

main();
