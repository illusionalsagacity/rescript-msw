/// <reference types="vitest" />
import { defineConfig } from "vitest/config";
import createReScriptPlugin from '@jihchi/vite-plugin-rescript';

export default defineConfig({
  plugins: [
    createReScriptPlugin({ silent: true }),
  ],
  test: {
    include: ['__tests__/*_test.res.js'],
    setupFiles: 'testUtils/setupTests.res.js',
    server: {
      deps: {
        fallbackCJS: true,
      },
    },
    deps: {
      optimizer: {
        ssr: {
          enabled: true,
        },
        web: {
          enabled: true,
        },
      },
    },
  }
});