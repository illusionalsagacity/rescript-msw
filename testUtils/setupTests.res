Vitest.beforeEach(() => {
  MSW.Server.resetHandlers(MSWServerInstance.server)
})

Vitest.beforeAll(() => {
  MSW.Server.listenWithOptions(MSWServerInstance.server, {onUnhandledRequest: #error})
})

Vitest.afterAll(() => {
  MSW.Server.close(MSWServerInstance.server)
})
