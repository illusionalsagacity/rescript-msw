/**
 * @type {import("jest").Config}
 */
const config = {
  automock: false,
  testEnvironment: "node",
  roots: [
    "<rootDir>/lib/js/src",
    "<rootDir>/lib/js/__tests__",
    "<rootDir>/lib/js/testUtils",
  ],
  testMatch: ["<rootDir>/lib/js/__tests__/*_test.cjs"],
  setupFiles: ["./setupTests.cjs"],
  setupFilesAfterEnv: ["./setupTestsAfterEnv.cjs"],
};

export default config;
