open! RescriptCore
open Vitest
open Fetch

external asResponse: MSW.HttpResponse.t => Response.t = "%identity"

describe(
  "HttpResponse",
  () => {
    test("Creates a Response", ctx => {
      let response = MSW.HttpResponse.make(
        #Undefined(Js.undefined),
        {status: 200, statusText: "OK"},
      )

      ctx->expect(response)->Expect.toBeTruthy
    })

    For.test([200, 204, 400, 500], "Creates a Response with status %d", (status, ctx) => {
      let response = MSW.HttpResponse.make(#Undefined(Js.undefined), {status, statusText: "OK"})
      let response = asResponse(response)

      ctx->expect(Fetch.Response.status(response))->Expect.toEqual(status)
    })

    For.test(["OK", "Hello, World!"], "Creates a Response with statusText %s", (
      statusText,
      ctx,
    ) => {
      let response = MSW.HttpResponse.make(#String("Hello, world!"), {status: 200, statusText})
      let response = asResponse(response)

      ctx->expect(Fetch.Response.statusText(response))->Expect.toEqual(statusText)
    })

    test("HttpResponse.error creates a Response", ctx => {
      let response = MSW.HttpResponse.error()
      let response = asResponse(response)

      ctx->expect(Fetch.Response.ok(response))->Expect.toBe(false)
    })

    test("HttpResponse.json creates a Response", ctx => {
      let response = MSW.HttpResponse.json(Js.Json.boolean(true), {status: 200, statusText: "OK"})
      let response = asResponse(response)

      let contentType = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")

      ctx->expect(contentType)->Expect.toBeSome(~some=Some("application/json"))
    })

    test("HttpResponse.jsonObj creates a Response", ctx => {
      let response = MSW.HttpResponse.jsonObj({"hello": "world"}, {status: 200, statusText: "OK"})
      let response = asResponse(response)

      let contentType = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")

      ctx->expect(contentType)->Expect.toBeSome(~some=Some("application/json"))
    })

    test("HttpResponse.text creates a Response", ctx => {
      let response = MSW.HttpResponse.text("Hello, World!", {status: 200, statusText: "OK"})
      let response = asResponse(response)

      let contentType = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")

      ctx->expect(contentType)->Expect.toBeSome(~some=Some("text/plain"))
    })

    test("HttpResponse.xml creates a Response", ctx => {
      let response = MSW.HttpResponse.xml(
        "<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>",
        {status: 200, statusText: "OK"},
      )

      let response = asResponse(response)

      let contentType = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")

      ctx->expect(contentType)->Expect.toBeSome(~some=Some("text/xml"))
    })

    test("HttpResponse.html creates a Response", ctx => {
      let response = MSW.HttpResponse.html(
        "<!DOCTYPE html><html><head></head><body></body></html>",
        {status: 200, statusText: "OK"},
      )
      let response = asResponse(response)

      let contentType = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")

      ctx->expect(contentType)->Expect.toBeSome(~some=Some("text/html"))
    })

    test("HttpResponse.arrayBuffer creates a Response", ctx => {
      let response = MSW.HttpResponse.arrayBuffer(
        Js.TypedArray2.ArrayBuffer.make(10),
        {status: 200, statusText: "OK"},
      )
      let response = asResponse(response)

      Console.log(response)
      let contentLength = Fetch.Response.headers(response)->Fetch.Headers.get("Content-Length")
      ctx->expect(contentLength)->Expect.toBeSome(~some=Some("10"))
    })

    test("HttpResponse.formData creates a Response", ctx => {
      let response = MSW.HttpResponse.formData(
        Fetch.FormData.make(),
        {status: 200, statusText: "OK"},
      )
      let response = asResponse(response)

      let contentType =
        Fetch.Response.headers(response)->Fetch.Headers.get("Content-Type")->Belt.Option.getExn
      ctx->expect(contentType)->Expect.String.toContain("multipart/form-data")
    })
  },
  ~concurrent=true,
)
