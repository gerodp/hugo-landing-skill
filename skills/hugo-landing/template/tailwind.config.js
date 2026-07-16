/** @type {import('tailwindcss').Config} */
const colors = require('tailwindcss/colors');

module.exports = {
  content: [
    './themes/**/*.html',
    './content/**/*.{md,html}',
    './themes/**/*.{js,css}',
    './layouts/**/*.html',
  ],
  theme: {
    extend: {
      fontFamily: {
        // Keep in sync with params.googleFont in config/_default/hugo.toml
        sans: [
          'Inter',
          '-apple-system',
          'BlinkMacSystemFont',
          'Segoe UI',
          'Roboto',
          'Helvetica Neue',
          'sans-serif',
        ],
      },
      colors: {
        // Brand color: swap for any Tailwind palette (colors.emerald, colors.rose, ...)
        // or define your own 50-900 scale.
        primary: colors.blue,
        ink: '#0b1120',
      },
    },
  },
  plugins: [],
}
