"use strict";

const {server} = require("./lib/js/testUtils/MSWServerInstance.cjs");

const { beforeAll, beforeEach, afterAll } = require("@jest/globals");

beforeAll(function () {
  server.listen({
    onUnhandledRequest: "error",
  });
});

beforeEach(function () {
  server.resetHandlers();
});

afterAll(function () {
  server.close();
});

/*  Not a pure module */
