# Dark theme

The theme's colors live in two layers, and a dark variant must override both:

1. **Semantic tokens** — all component rules in
   `themes/landing/assets/css/main.css` use the CSS custom properties defined
   in its `:root` block (`--color-bg`, `--color-surface`, `--color-text`,
   `--color-border`, …). One override block re-skins every component.
2. **Tailwind utility classes hardcoded in the layouts** (`bg-white`,
   `text-slate-900`, `border-slate-200`, …). These don't read the tokens, so
   they need class-level remaps. The full inventory is below — do NOT
   rediscover it by grepping.

Note: `tailwind.config.js`'s `primary` palette is only the ACCENT color.
Swapping it does not produce a dark theme.

## Ready-made dark override

Paste at the end of `main.css` (everything there comes after
`@tailwind utilities` in the build, so these rules win over the utilities).
It's a solid starting point — do a visual pass afterwards and tune to taste.

```css
/* ===== Dark theme ===== */
:root {
  --color-bg: #0b1120;
  --color-surface: #0f172a;
  --color-surface-2: #1e293b;
  --color-text: #f1f5f9;
  --color-text-body: #cbd5e1;
  --color-text-muted: #94a3b8;
  --color-border: #1e293b;
  --color-border-strong: #334155;
  --panel-bg: rgb(15 23 42 / 88%);
  --panel-border: rgb(51 65 85 / 80%);
  --hero-wash-from: rgb(11 17 32 / 72%);
  --hero-wash-to: rgb(15 23 42 / 88%);
  --hero-tint: #1e1b4b;
  --oss-glow: rgb(30 58 138 / 35%);
}

/* Unstyled-link fallback color (default is #00e — invisible on dark) */
a:not([class]) { color: theme('colors.primary.400'); }

/* Tailwind utility remaps: backgrounds */
.bg-white { background-color: #111827; }
.bg-white\/95 { background-color: rgb(17 24 39 / 95%); }  /* header */
.bg-white\/80 { background-color: rgb(17 24 39 / 80%); }
.bg-slate-50, .bg-gray-50, .hover\:bg-gray-50:hover { background-color: #0f172a; }
.bg-slate-50\/70 { background-color: rgb(15 23 42 / 70%); }
.bg-slate-100, .bg-gray-100 { background-color: #1e293b; }
.bg-gray-200, .hover\:bg-gray-200:hover { background-color: #334155; }
.bg-primary-50 { background-color: rgb(37 99 235 / 15%); }

/* Tailwind utility remaps: text */
.text-slate-950, .text-gray-950, .text-slate-900, .text-gray-900,
.text-gray-800, .hover\:text-gray-900:hover { color: #f1f5f9; }
.text-slate-700, .text-gray-700, .hover\:text-gray-700:hover { color: #cbd5e1; }
.text-slate-600, .text-gray-600 { color: #94a3b8; }
.text-slate-500, .text-gray-500 { color: #7c8ba1; }

/* Tailwind utility remaps: borders */
.border-slate-200, .border-slate-100, .border-gray-200, .border-gray-100 { border-color: #1e293b; }
.border-slate-300 { border-color: #334155; }
.divide-slate-200 > * + * { border-color: #1e293b; }
```

Leave the already-dark parts alone: the case-studies section
(`bg-slate-950`, `.case-card`), the contact panel, the footer (`bg-black`),
`.prose pre` code blocks, and their `text-white` / `text-slate-300` /
`text-gray-300` / `border-white/10` utilities all work unchanged on a dark
site.

## Checklist after applying

- `params.themeColor` in hugo.toml → the dark background hex.
- `static/favicon.svg` — make sure it's visible on dark browser chrome.
- Hero: check the grid overlay (`.home-hero::before`) and orb borders are
  still subtle; drop their opacity if they glow too much.
- Shadows (`rgb(15 23 42 / …)`) read as near-black on dark backgrounds —
  usually fine, occasionally worth removing on cards.
- Skim every homepage section plus one blog post and one legal page
  (blog/legal templates use `bg-gray-50`/`bg-white` utilities remapped
  above).

## Toggleable dark mode

For a user-switchable theme instead of an always-dark site, wrap every rule
above in `html[data-theme='dark']` (the token block becomes
`html[data-theme='dark'] { … }` instead of `:root { … }`) and toggle the
attribute with a small script. The remaps gain specificity from the parent
selector, so they still win.
