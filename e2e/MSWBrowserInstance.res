/**
 * Creates a shared MSW service worker instance for browser tests.
 * This worker intercepts fetch requests in the browser environment.
 */
let worker = MSW.setupWorker()
