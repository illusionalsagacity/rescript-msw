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

describe("MSW__REST", () => {
  open MSW

  let server = setupServer()

  beforeAll(() => Server.listenWithOptions(server, {onUnhandledRequest: #error}))

  afterEach(() => Server.resetHandlers(server))

  afterAll(() => Server.close(server))

  describe("get", () => {
    testPromise(
      "should return data for a response",
      () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        server->Server.use(
          REST.get(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #GET})
        ->Promise.then(Fetch.Response.json)
        ->Promise.thenResolve(
          json => {
            json
            ->JsonCombinators.Json.decode(Decode.stockPrice)
            ->Belt.Result.getExn
            ->expect
            ->toEqual(value)
          },
        )
      },
    )
  })

  describe("post", () => {
    testPromise(
      "should return data for a response",
      () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        server->Server.use(
          REST.post(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #POST})
        ->Promise.then(Fetch.Response.json)
        ->Promise.thenResolve(
          json => {
            json
            ->JsonCombinators.Json.decode(Decode.stockPrice)
            ->Belt.Result.getExn
            ->expect
            ->toEqual(value)
          },
        )
      },
    )
  })

  describe("put", () => {
    testPromise(
      "should return data for a response",
      () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        server->Server.use(
          REST.put(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #PUT})
        ->Promise.then(Fetch.Response.json)
        ->Promise.thenResolve(
          json => {
            json
            ->JsonCombinators.Json.decode(Decode.stockPrice)
            ->Belt.Result.getExn
            ->expect
            ->toEqual(value)
          },
        )
      },
    )
  })
  describe("patch", () => {
    testPromise(
      "should return data for a response",
      () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        server->Server.use(
          REST.patch(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(200, ~text="OK")->ctx.json(Encode.stockPrice(value))
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #PATCH})
        ->Promise.then(Fetch.Response.json)
        ->Promise.thenResolve(
          json => {
            json
            ->JsonCombinators.Json.decode(Decode.stockPrice)
            ->Belt.Result.getExn
            ->expect
            ->toEqual(value)
          },
        )
      },
    )
  })
  describe("delete", () => {
    testPromise(
      "should return data for a response",
      () => {
        server->Server.use(
          REST.delete(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(204, ~text="No Content")
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #DELETE})->Promise.thenResolve(
          response => {
            response->Fetch.Response.statusText->expect->toEqual("No Content")
          },
        )
      },
    )
  })
  describe("options", () => {
    testPromise(
      "should return data for a response",
      () => {
        server->Server.use(
          REST.options(
            #String("http://localhost:8080/"),
            (_req, {res, _}, ctx) => {
              res()->ctx.status(204, ~text="No Content")
            },
          ),
        )

        Fetch.fetch("http://localhost:8080/", {method: #OPTIONS})->Promise.thenResolve(
          response => {
            response->Fetch.Response.statusText->expect->toEqual("No Content")
          },
        )
      },
    )
  })

  describe("response", () => {
    testPromise(
      "should return error for networkError",
      () => {
        server->Server.use(
          REST.get(
            #String("http://localhost:8080/"),
            (_req, {networkError, _}, _ctx) => {
              networkError("Oops")
            },
          ),
        )

        Fetch.get("http://localhost:8080/")
        ->Promise.then(_ => Promise.resolve(Ok()))
        ->Promise.catch(error => Promise.resolve(Error(error)))
        ->Promise.thenResolve(value => value->Belt.Result.isError->expect->toBe(true))
      },
    )
  })
})
