open! RescriptCore
open Vitest
open MSW

let url = "http://localhost:8080"

describe("Delay", () => {
  beforeAll(() => {
    let _ = Vi.useFakeTimers()
  })

  afterAll(() => {
    let _ = Vi.useRealTimers()
  })

  testAsync("should handle a realistic delayed response", async ctx => {
    MSWServerInstance.server->Server.use(
      Http.all(
        #URL(url),
        async _options => {
          await Delay.realistic()
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        ~options={once: true},
      ),
    )

    let response = Fetch.fetch(url, {method: #GET})
    let _ = await Vi.advanceTimersToNextTimerAsync()
    let response = await response
    let statusText = Fetch.Response.statusText(response)
    ctx->expect(statusText)->Expect.toEqual("No Content")
  })

  testAsync("should handle an explicit delayed response", async ctx => {
    MSWServerInstance.server->Server.use(
      Http.all(
        #URL(url),
        async _options => {
          await Delay.delay(1000)
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        ~options={once: true},
      ),
    )

    let response = Fetch.fetch(url, {method: #GET})
    let _ = await Vi.advanceTimersToNextTimerAsync()
    let response = await response
    let statusText = Fetch.Response.statusText(response)
    ctx->expect(statusText)->Expect.toEqual("No Content")
  })

  testAsync("should handle an infinitely delayed response", async ctx => {
    MSWServerInstance.server->Server.use(
      Http.all(
        #URL(url),
        async _options => {
          await Delay.infinite()
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        ~options={once: true},
      ),
    )

    let abortController = Fetch.AbortController.make()
    let response = Promise.race([
      Fetch.fetch(
        url,
        {method: #GET, signal: Fetch.AbortController.signal(abortController)},
      )->Promise.thenResolve(_ => #responded),
      Delay.delay(4_000)->Promise.thenResolve(_ => #timedOut),
    ])

    let _ = await Vi.advanceTimersToNextTimerAsync()
    let response = await response

    ctx->expect(response)->Expect.toEqual(#timedOut)
  })

  testAsync("should handle an aborted response", async ctx => {
    MSWServerInstance.server->Server.use(
      Http.all(
        #URL(url),
        async _options => {
          await Delay.infinite()
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        ~options={once: true},
      ),
    )

    let signal = Fetch.AbortSignal.timeout(200)
    let response = Fetch.fetch(url, {method: #GET, signal})->Promise.thenResolve(_ => #responded)

    // this doesn't actually work, because AbortSignal.timeout is not faked
    // see: https://github.com/sinonjs/fake-timers/issues/418
    let _ = await Vi.advanceTimersByTimeAsync(201)

    await ctx
    ->expect(response)
    ->Expect.Promise.rejects
    ->Expect.Promise.toThrowError(~message="The operation was aborted due to timeout")
  })
})
