/* global umami, plausible, gtag */
// Provider-agnostic event tracking (Umami, Plausible or GA4).
// Opt elements in with data attributes:
//   data-analytics-event="event-name"  -> tracked on click
//   data-analytics-view="event-name"   -> tracked once when 50% visible
// External links and scroll depth are tracked automatically.
(function () {
  'use strict';

  function track(eventName, eventData) {
    try {
      if (typeof umami !== 'undefined' && umami.track) {
        umami.track(eventName, eventData);
      } else if (typeof plausible !== 'undefined') {
        plausible(eventName, eventData ? { props: eventData } : undefined);
      } else if (typeof gtag !== 'undefined') {
        gtag('event', eventName, eventData || {});
      }
    } catch (error) {
      console.warn('analytics: failed to track event', eventName, error);
    }
  }

  function init() {
    // Click events
    document.querySelectorAll('[data-analytics-event]').forEach(function (el) {
      el.addEventListener('click', function () {
        track(el.getAttribute('data-analytics-event'));
      });
    });

    // View events (fire once when half the element is visible)
    if (typeof IntersectionObserver !== 'undefined') {
      const seen = new WeakSet();
      const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting && !seen.has(entry.target)) {
            seen.add(entry.target);
            track(entry.target.getAttribute('data-analytics-view'));
            observer.unobserve(entry.target);
          }
        });
      }, { threshold: 0.5 });
      document.querySelectorAll('[data-analytics-view]').forEach(function (el) {
        observer.observe(el);
      });
    }

    // External link clicks
    const host = window.location.hostname;
    document.querySelectorAll('a[href^="http"]').forEach(function (link) {
      let url;
      try {
        url = new URL(link.href);
      } catch {
        return;
      }
      if (url.hostname === host) return;
      link.addEventListener('click', function () {
        track('external-link', { url: link.href });
      });
    });

    // Scroll depth (25 / 50 / 75 / 100)
    const milestones = [25, 50, 75, 100];
    const fired = new Set();
    window.addEventListener('scroll', function () {
      const scrollable = document.documentElement.scrollHeight - window.innerHeight;
      if (scrollable <= 0) return;
      const percent = Math.round((window.scrollY / scrollable) * 100);
      milestones.forEach(function (m) {
        if (percent >= m && !fired.has(m)) {
          fired.add(m);
          track('scroll-depth', { depth: m + '%' });
        }
      });
    }, { passive: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
