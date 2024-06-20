open Jest
open Expect

type response<'a> = {..} as 'a

type tick = {
  openingPrice: int,
  closingPrice: int,
}

type stockPrice = {history: array<tick>}

module Decode = {
  open JsonCombinators.Json.Decode

  let point = object(field => {
    openingPrice: field.required(. "openingPrice", int),
    closingPrice: field.required(. "closingPrice", int),
  })

  let stockPrice = object(field => {
    history: field.required(. "history", array(point)),
  })
}

module Encode = {
  open JsonCombinators.Json.Encode

  let tick = value =>
    object([("openingPrice", int(value.openingPrice)), ("closingPrice", int(value.closingPrice))])

  let stockPrice = value => object([("history", array(tick, value.history))])
}

let url = "http://localhost:8080"

describe("MSW__REST", () => {
  open MSW

  describe("get", () => {
    testPromise(
      "should return data for a response",
      async () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          REST.get(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        let result = await Fetch.fetch(url, {method: #GET})
        let json = await Fetch.Response.json(result)

        JsonCombinators.Json.decode(json, Decode.stockPrice)
        ->Belt.Result.getExn
        ->expect
        ->toEqual(value)
      },
    )
  })

  describe("post", () => {
    testPromise(
      "should return data for a response",
      async () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          REST.post(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #POST})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Belt.Result.getExn
        ->expect
        ->toEqual(value)
      },
    )
  })

  describe("put", () => {
    testPromise(
      "should return data for a response",
      async () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          REST.put(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #PUT})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Belt.Result.getExn
        ->expect
        ->toEqual(value)
      },
    )
  })

  describe("patch", () => {
    testPromise(
      "should return data for a response",
      async () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        MSWServerInstance.server->Server.use(
          REST.patch(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #PATCH})
        let json = await Fetch.Response.json(response)
        json
        ->JsonCombinators.Json.decode(Decode.stockPrice)
        ->Belt.Result.getExn
        ->expect
        ->toEqual(value)
      },
    )
  })
  describe("delete", () => {
    testPromise(
      "should return data for a response",
      async () => {
        MSWServerInstance.server->Server.use(
          REST.delete(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(204, ~text="No Content")
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #DELETE})
        response->Fetch.Response.statusText->expect->toEqual("No Content")
      },
    )
  })
  describe("options", () => {
    testPromise(
      "should return data for a response",
      async () => {
        MSWServerInstance.server->Server.use(
          REST.options(
            #URL(url),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(204, ~text="No Content")
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #OPTIONS})
        response->Fetch.Response.statusText->expect->toEqual("No Content")
      },
    )
  })

  describe("response", () => {
    testPromise(
      "should return error for networkError",
      async () => {
        MSWServerInstance.server->Server.use(
          REST.get(
            #URL(url),
            (_req, {networkError, _}, _ctx) => {
              networkError("Oops")
            },
          ),
        )

        let result = try {
          let _ = await Fetch.get(url)
          None
        } catch {
        | Js.Exn.Error(e) => Some(e)
        }

        let error = Belt.Option.getExn(result)
        let name = Js.Exn.name(error)->Belt.Option.getExn
        let message = Js.Exn.message(error)->Belt.Option.getExn
        expect((name, message))->toEqual(("TypeError", "Failed to fetch"))
      },
    )
  })
})
