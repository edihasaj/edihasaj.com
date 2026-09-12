const { spawnSync } = require('child_process');

test('rendered pages have valid social cards, metadata, and writing links', () => {
  const result = spawnSync('bundle', ['exec', 'ruby', 'tests/site_test.rb'], {
    encoding: 'utf8',
    timeout: 30000,
  });
  if (result.status !== 0) throw new Error(result.stdout + result.stderr);
}, 35000);
