'use strict';

(() => {
  const toc = document.querySelector('.post-toc');
  const body = document.querySelector('.c-post__body');
  if (!toc || !body) return;
  const headings = [...body.querySelectorAll('h2')];
  if (headings.length < 2) return;

  const toggle = toc.querySelector('.toc-toggle');
  const panel = toc.querySelector('.toc-panel');
  const list = toc.querySelector('.toc-list');
  const desktop = window.matchMedia('(min-width: 1200px)');
  const links = headings.map((heading, index) => {
    if (!heading.id) {
      let id = `section-${index + 1}`;
      while (document.getElementById(id)) id += '-section';
      heading.id = id;
    }
    heading.tabIndex = -1;
    const link = document.createElement('a');
    link.href = `#${encodeURIComponent(heading.id)}`;
    link.textContent = heading.textContent;
    const item = document.createElement('li');
    item.append(link);
    list.append(item);
    link.addEventListener('click', () => {
      heading.focus({ preventScroll: true });
      if (!desktop.matches) setOpen(false);
    });
    return link;
  });

  function setOpen(open) {
    panel.hidden = !open;
    toggle.setAttribute('aria-expanded', String(open));
    toggle.setAttribute('aria-label', open ? 'Close table of contents' : 'Open table of contents');
    toggle.querySelector('.toc-toggle__icon').textContent = open ? '×' : '☰';
  }

  function restore() {
    let closed = false;
    try { closed = localStorage.getItem('toc-closed') === 'true'; } catch (_) {}
    setOpen(desktop.matches && !closed);
  }
  toggle.addEventListener('click', () => {
    const open = panel.hidden;
    setOpen(open);
    if (desktop.matches) {
      try { localStorage.setItem('toc-closed', String(!open)); } catch (_) {}
    }
  });
  toc.addEventListener('keydown', event => {
    if (event.key === 'Escape' && !panel.hidden) {
      setOpen(false);
      if (desktop.matches) {
        try { localStorage.setItem('toc-closed', 'true'); } catch (_) {}
      }
      toggle.focus();
    }
  });
  desktop.addEventListener('change', restore);
  toc.hidden = false;
  restore();

  let scheduled = false;
  function updateActive() {
    let active = -1;
    headings.forEach((heading, index) => {
      if (heading.getBoundingClientRect().top <= 180) active = index;
    });
    links.forEach((link, index) => {
      if (index === active) link.setAttribute('aria-current', 'location');
      else link.removeAttribute('aria-current');
    });
    scheduled = false;
  }
  window.addEventListener('scroll', () => {
    if (!scheduled) {
      scheduled = true;
      requestAnimationFrame(updateActive);
    }
  }, { passive: true });
  updateActive();
})();
