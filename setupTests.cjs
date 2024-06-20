const crossFetch = require("cross-fetch");
globalThis.fetch = crossFetch.fetch;
globalThis.Request = crossFetch.Request;
globalThis.Response = crossFetch.Response;
globalThis.Headers = crossFetch.Headers;
