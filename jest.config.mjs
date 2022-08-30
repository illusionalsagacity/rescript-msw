/**
 * @type {import("jest").Config}
 */
const config = {
  automock: false,
  // runner: "jest-light-runner",
  testEnvironment: "node",
  transform: {},
  roots: ["<rootDir>/lib/js", "<rootDir>/lib/js/__tests__"],
  testMatch: ["<rootDir>/lib/js/__tests__/*_test.cjs"],
  setupFiles: ["./setupTests.cjs"],
};

export default config;
