open Jest
open Expect
open MSW

let url = "http://localhost:8080"

describe("Delay", () => {
  testPromise("should handle a realistic delayed response", async () => {
    MSWServerInstance.server->Server.use(
      Http.allWithOptions(
        #URL(url),
        async _options => {
          await Delay.realistic()
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        {once: true},
      ),
    )

    let response = await Fetch.fetch(url, {method: #GET})
    response->Fetch.Response.statusText->expect->toEqual("No Content")
  })

  testPromise("should handle an explicit delayed response", async () => {
    MSWServerInstance.server->Server.use(
      Http.allWithOptions(
        #URL(url),
        async _options => {
          await Delay.delay(1000)
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        {once: true},
      ),
    )

    let response = await Fetch.fetch(url, {method: #GET})
    response->Fetch.Response.statusText->expect->toEqual("No Content")
  })

  // this test is leaking according to jest
  testPromise("should handle an explicit delayed response", async () => {
    MSWServerInstance.server->Server.use(
      Http.allWithOptions(
        #URL(url),
        async _options => {
          await Delay.infinite()
          Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
        },
        {once: true},
      ),
    )

    let abortController = Fetch.AbortController.make()
    let response = await Promise.race([
      Fetch.fetch(
        url,
        {method: #GET, signal: Fetch.AbortController.signal(abortController)},
      )->Promise.thenResolve(_ => #responded),
      Delay.delay(4_000)->Promise.thenResolve(_ => #timedOut),
    ])
    Fetch.AbortController.abort(abortController, ())

    response->expect->toEqual(#timedOut)
  })
})
