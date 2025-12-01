/**
 * Browser test setup file for MSW.
 *
 * This file configures the MSW service worker lifecycle for Vitest browser tests.
 * The service worker intercepts fetch requests directly in the browser,
 * allowing you to mock HTTP responses without a running server.
 */

Vitest.beforeAllAsync(async () => {
  // Start the service worker before all tests
  await MSW.ServiceWorker.startWithOptions(
    MSWBrowserInstance.worker,
    {
      // Throw an error when a request is not handled by any mock
      onUnhandledRequest: #error,
    },
  )
})

Vitest.beforeEach(() => {
  // Reset handlers to initial state before each test
  MSW.ServiceWorker.resetHandlers(MSWBrowserInstance.worker)
})

Vitest.afterAll(() => {
  // Stop the service worker after all tests complete
  MSW.ServiceWorker.stop(MSWBrowserInstance.worker)
})
