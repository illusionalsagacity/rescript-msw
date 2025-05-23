open! RescriptCore
open Vitest

type response<'a> = {..} as 'a

type tick = {
  openingPrice: int,
  closingPrice: int,
}

type stockPrice = {history: array<tick>}

module Decode = {
  open JsonCombinators.Json.Decode

  let point = object(field => {
    openingPrice: field.required("openingPrice", int),
    closingPrice: field.required("closingPrice", int),
  })

  let stockPrice = object(field => {
    history: field.required("history", array(point)),
  })
}

module Encode = {
  open JsonCombinators.Json.Encode

  let tick = value =>
    object([("openingPrice", int(value.openingPrice)), ("closingPrice", int(value.closingPrice))])

  let arrayOfTicks = array(tick)

  let stockPrice = value => object([("history", arrayOfTicks(value.history))])
}

let url = "http://localhost:8080"

describe("MSW__Http", () => {
  open MSW

  describe("get", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          Http.get(
            #URL(url),
            async _options => {
              Encode.stockPrice(value)->Http.Response.json({status: 200, statusText: "OK"})
            },
          ),
        )

        let result = await Fetch.fetch(url, {method: #GET})
        let json = await Fetch.Response.json(result)

        JsonCombinators.Json.decode(json, Decode.stockPrice)
        ->Result.getExn
        ->expect
        ->Expect.toEqual(value)
      },
    )
  })

  describe("post", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          Http.post(
            #URL(url),
            async _options => {
              Encode.stockPrice(value)->Http.Response.json({status: 200, statusText: "OK"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #POST})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Result.getExn
        ->expect
        ->Expect.toEqual(value)
      },
    )
  })

  describe("put", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          Http.put(
            #URL(url),
            async _options => {
              Encode.stockPrice(value)->Http.Response.json({status: 200, statusText: "OK"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #PUT})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Result.getExn
        ->expect
        ->Expect.toEqual(value)
      },
    )
  })

  describe("patch", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          Http.patch(
            #URL(url),
            async _options => {
              Encode.stockPrice(value)->Http.Response.json({status: 200, statusText: "OK"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #PATCH})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Result.getExn
        ->expect
        ->Expect.toEqual(value)
      },
    )
  })

  describe("delete", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        MSWServerInstance.server->Server.use(
          Http.delete(
            #URL(url),
            async _options => {
              Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #DELETE})
        response->Fetch.Response.statusText->expect->Expect.toEqual("No Content")
      },
    )
  })

  describe("options", () => {
    testAsync(
      "should return data for a response",
      async t => {
        let expect = expect(t, ...)
        MSWServerInstance.server->Server.use(
          Http.options(
            #URL(url),
            async _options => {
              Http.Response.make(#Undefined(Js.undefined), {status: 204, statusText: "No Content"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #OPTIONS})
        response->Fetch.Response.statusText->expect->Expect.toEqual("No Content")
      },
    )
  })

  describe("response", () => {
    testAsync(
      "should return error for networkError",
      async t => {
        let expect = expect(t, ...)
        MSWServerInstance.server->Server.use(
          Http.get(#URL(url), async _options => Http.Response.error()),
        )

        let result = try {
          let _ = await Fetch.get(url)
          Assert.unreachable(~message="Expected networkError", ())
          None
        } catch {
        | Js.Exn.Error(e) => Some(e)
        }

        let error = Option.getExn(result)
        let name = Js.Exn.name(error)->Option.getExn
        let message = Js.Exn.message(error)->Option.getExn
        (name, message)->expect->Expect.not->Expect.toEqual(("TypeError", "Failed to fetch"))
      },
    )
  })
})
