open! RescriptCore
open Vitest

external asResponse: MSW.HttpResponse.t => Fetch.Response.t = "%identity"

Concurrent.describe("HttpResponse", () => {
  test("Creates a Response", _suite => {
    let response = MSW.HttpResponse.make(#Undefined(Js.undefined), {status: 200, statusText: "OK"})

    expect(response)->Expect.toBeTruthy
  })

  Each.test([200, 204, 400, 500], "Creates a Response with status %d", status => {
    let response = MSW.HttpResponse.make(#Undefined(Js.undefined), {status, statusText: "OK"})
    let response = asResponse(response)

    Fetch.Response.status(response)->expect->Expect.toEqual(status)
  })

  Each.test(["OK", "Hello, World!"], "Creates a Response with statusText %s", statusText => {
    let response = MSW.HttpResponse.make(#String("Hello, world!"), {status: 200, statusText})
    let response = asResponse(response)

    Fetch.Response.statusText(response)->expect->Expect.toEqual(statusText)
  })

  test("HttpResponse.error creates a Response", _suite => {
    let response = MSW.HttpResponse.error()
    let response = asResponse(response)

    Fetch.Response.ok(response)->expect->Expect.toBe(false)
  })

  test("HttpResponse.json creates a Response", _suite => {
    let response = MSW.HttpResponse.json(Js.Json.boolean(true), {status: 200, statusText: "OK"})
    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->expect
    ->Expect.toBeSome(~some=Some("application/json"))
  })

  test("HttpResponse.jsonObj creates a Response", _suite => {
    let response = MSW.HttpResponse.jsonObj({"hello": "world"}, {status: 200, statusText: "OK"})
    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->expect
    ->Expect.toBeSome(~some=Some("application/json"))
  })

  test("HttpResponse.text creates a Response", _suite => {
    let response = MSW.HttpResponse.text("Hello, World!", {status: 200, statusText: "OK"})
    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->expect
    ->Expect.toBeSome(~some=Some("text/plain"))
  })

  test("HttpResponse.xml creates a Response", _suite => {
    let response = MSW.HttpResponse.xml(
      "<note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>",
      {status: 200, statusText: "OK"},
    )

    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->expect
    ->Expect.toBeSome(~some=Some("text/xml"))
  })

  test("HttpResponse.html creates a Response", _suite => {
    let response = MSW.HttpResponse.html(
      "<!DOCTYPE html><html><head></head><body></body></html>",
      {status: 200, statusText: "OK"},
    )
    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->expect
    ->Expect.toBeSome(~some=Some("text/html"))
  })

  test("HttpResponse.arrayBuffer creates a Response", _suite => {
    let response = MSW.HttpResponse.arrayBuffer(
      Js.TypedArray2.ArrayBuffer.make(10),
      {status: 200, statusText: "OK"},
    )
    let response = asResponse(response)

    Console.log(response)
    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Length")
    ->expect
    ->Expect.toBeSome(~some=Some("10"))
  })

  test("HttpResponse.formData creates a Response", _suite => {
    let response = MSW.HttpResponse.formData(Fetch.FormData.make(), {status: 200, statusText: "OK"})
    let response = asResponse(response)

    Fetch.Response.headers(response)
    ->Fetch.Headers.get("Content-Type")
    ->Option.getExn
    ->expect
    ->Expect.String.toContain("multipart/form-data")
  })
})
