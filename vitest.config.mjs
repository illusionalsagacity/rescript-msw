/// <reference types="vitest" />
import path from "node:path";
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    coverage: {
      exclude: [
        "**/__tests__/**",
        "**/testUtils/**",
        "**/e2e/**",
        "lib/**",
        "vitest.config.mjs",
      ],
    },
    reporters: process.env.GITHUB_ACTIONS
      ? ["verbose", "github-actions", "junit"]
      : ["default"],
    outputFile: {
      junit: path.resolve("test-results", "junit.xml"),
    },
    projects: [
      {
        // Node.js tests (existing tests using msw/node)
        test: {
          name: "node",
          environment: "node",
          include: [path.resolve("__tests__", "*_test.res.js")],
          setupFiles: path.resolve("testUtils", "setupTests.res.js"),
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
        },
      },
      {
        // Browser tests (using msw/browser with service worker)
        test: {
          name: "browser",
          include: [path.resolve("e2e", "*_test.res.js")],
          setupFiles: path.resolve("e2e", "setupBrowserTests.res.js"),
          browser: {
            enabled: true,
            headless: true,
            provider: "playwright",
            instances: [{ browser: "chromium" }],
          },
        },
        publicDir: path.resolve("public"),
      },
    ],
  },
});
