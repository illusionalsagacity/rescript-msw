/// <reference types="vitest" />
import path from "node:path";
import { defineConfig } from "vitest/config";
import createReScriptPlugin from "@jihchi/vite-plugin-rescript";

export default defineConfig({
  plugins: [createReScriptPlugin({ silent: true })],
  test: {
    include: [path.resolve("__tests__", "*_test.res.js")],
    setupFiles: path.resolve("testUtils", "setupTests.res.js"),
    server: {
      deps: {
        fallbackCJS: true,
      },
    },
    reporters: process.env.GITHUB_ACTIONS
      ? ["verbose", "github-actions", "junit"]
      : ["default"],
    outputFile: {
      junit: path.resolve("test-results", "junit.xml"),
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
});
