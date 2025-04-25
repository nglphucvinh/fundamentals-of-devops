// eslint.config.mjs - Simple ESLint configuration for JavaScript
import globals from 'globals';
import js from '@eslint/js';

export default [
  // Base JS configuration
  js.configs.recommended,

  // Add global environments
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node,
        ...globals.es2021,
      },
      ecmaVersion: 2022,
      sourceType: 'module',
    },
  },

  // Custom rules
  {
    rules: {
      'no-console': 'warn',
      'no-unused-vars': 'error',
      semi: ['error', 'always'],
      quotes: ['error', 'single'],
      indent: ['error', 2],
    },
  },
];
