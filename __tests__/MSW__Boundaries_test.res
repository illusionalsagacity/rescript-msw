open! RescriptCore
open Vitest
open MSW

let url = "http://localhost:8080"
let fetch = () => Fetch.fetch(url, {method: #GET})
let makeFixture = (status, statusText) => {
  Http.get(#URL(url), async _options => {
    Http.Response.make(#Undefined(Js.undefined), {status, statusText})
  })
}

describe(
  "runs tests in parallel without interference",
  Server.boundary(MSWServerInstance.server, () => {
    For.testAsync(
      [
        (200, "OK"),
        (204, "Accepted"),
        (304, "Not Modified"),
        (400, "Bad Request"),
        (404, "Not Found"),
        (429, "Too Many Requests"),
        (500, "Internal Server Error"),
        (503, "Service Unavailable"),
        (504, "Gateway Timeout"),
        (529, "Site is overloaded"),
      ],
      "receives an %d '%s' response",
      async ((status, statusText), ctx) => {
        MSWServerInstance.server->Server.use(makeFixture(status, statusText))

        let response = await fetch()
        ctx->expect(Fetch.Response.statusText(response))->Expect.toEqual(statusText)
        ctx->expect(Fetch.Response.status(response))->Expect.toEqual(status)
      },
      ~concurrent=true,
    )
  }),
)
