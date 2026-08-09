const fs = require('fs');

const head = fs.readFileSync('_includes/head.html', 'utf8');
const jsonLd = fs.readFileSync('_includes/seo-jsonld.html', 'utf8');
const home = fs.readFileSync('index.html', 'utf8');

test('social images are page-specific instead of globally forced', () => {
  expect(head).toContain('page.og_image | default: page.image');
  expect(head).toContain('{% if og_image and og_image != \'\' %}');
  expect(head).not.toContain("default: '/images/pages/edi-og.png'");
  expect(jsonLd).not.toContain("default: '/images/pages/edi-og.png'");
});

test('image-less pages use a summary card and can explicitly opt out', () => {
  expect(head).toContain('page.og_image == false');
  expect(head).toContain('summary_large_image{% else %}summary');
  expect(jsonLd).toContain('page.og_image == false');
});

test('the homepage opts into Edi portrait metadata', () => {
  expect(home).toContain('og_image: /images/header-edi.jpg');
  expect(home).toContain('og_image_alt: Edi Hasaj');
});
