const js = require('@eslint/js');

module.exports = [
  js.configs.recommended,
  {
    // Node.js files (config files)
    files: ['*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'script',
      globals: {
        require: 'readonly',
        module: 'readonly',
        exports: 'readonly',
        process: 'readonly',
        __dirname: 'readonly',
        console: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      'prefer-const': 'error',
      'no-var': 'error',
      eqeqeq: 'error',
    },
  },
  {
    // Browser files (theme JS)
    files: ['themes/**/*.js'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'script',
      globals: {
        window: 'readonly',
        document: 'readonly',
        console: 'readonly',
        URL: 'readonly',
        Set: 'readonly',
        WeakSet: 'readonly',
        IntersectionObserver: 'readonly',
      },
    },
    rules: {
      'no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      'prefer-const': 'error',
      'no-var': 'error',
      eqeqeq: 'error',
    },
  },
  {
    ignores: ['public/**', 'resources/**', 'node_modules/**'],
  },
];
