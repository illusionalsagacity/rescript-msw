globalThis.ReadableStream = require("node:stream/web").ReadableStream;
globalThis.TextDecoder = require("node:util").TextDecoder;
globalThis.TextEncoder = require("node:util").TextEncoder;

const { fetch, Request, Response, Headers, File, FormData } = require("undici");
globalThis.fetch = fetch;
globalThis.Request = Request;
globalThis.Response = Response;
globalThis.Headers = Headers;
globalThis.File = File;
globalThis.FormData = FormData;
globalThis.Blob = require("node:buffer").Blob;

