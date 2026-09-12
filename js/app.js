'use strict';

const themeToggle = document.querySelector('.js-theme-toggle');
if (themeToggle) {
  function updateToggle() {
    const dark = document.documentElement.classList.contains('theme-dark');
    themeToggle.setAttribute('aria-pressed', String(dark));
    themeToggle.setAttribute('aria-label', dark ? 'Switch to light mode' : 'Switch to dark mode');
  }
  themeToggle.hidden = false;
  updateToggle();
  themeToggle.addEventListener('click', () => {
    const dark = document.documentElement.classList.toggle('theme-dark');
    try { localStorage.setItem('theme', dark ? 'dark' : 'light'); } catch (_) {}
    updateToggle();
  });
}
