$(document).ready(function() {

  'use strict';

  // =================
  // Responsive videos
  // =================

  $('.o-wrapper').fitVids({
    'customSelector': ['iframe[src*="ted.com"]']
  });

  // =================
  // Off Canvas menu
  // =================

  $('.js-off-canvas-toggle').click(function(e) {
    e.preventDefault();
    $('.js-off-canvas-toggle').toggleClass('is-active');
    $('.js-off-canvas-container').toggleClass('is-active');
  });

  // =================
  // Theme
  // =================

  var $html = $('html');
  var $themeToggle = $('.js-theme-toggle');

  function setTheme(isDark) {
    $html.toggleClass('theme-dark', isDark);
    $themeToggle.attr('aria-pressed', isDark ? 'true' : 'false');
    $themeToggle.attr('aria-label', isDark ? 'Switch to light mode' : 'Switch to dark mode');
    $themeToggle.attr('title', isDark ? 'Switch to light mode' : 'Switch to dark mode');
  }

  var savedTheme = null;
  try {
    savedTheme = localStorage.getItem('theme');
  } catch (e) {}
  var prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  setTheme(savedTheme ? savedTheme === 'dark' : prefersDark);

  $themeToggle.click(function() {
    var isDark = !$html.hasClass('theme-dark');
    try {
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    } catch (e) {}
    setTheme(isDark);
  });

});
