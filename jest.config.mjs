/**
 * @type {import("jest").Config}
 */
const config = {
  automock: false,
  testEnvironment: "node",
  roots: ["<rootDir>/lib/js", "<rootDir>/lib/js/__tests__"],
  testMatch: ["<rootDir>/lib/js/__tests__/*_test.cjs"],
  setupFiles: ["./setupTests.cjs"],
};

export default config;
