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

@send
external json: response<'a> => Js.Promise.t<Js.Json.t> = "json"

@val
external fetch: (string, ~init: RequestInit.t=?, unit) => Js.Promise.t<response<'a>> = "fetch"

describe("MSW__REST", () => {
  let server = MSW.setupServer()

  beforeAll(() => MSW.Server.listenWithOptions(server, {onUnhandledRequest: #error}))

  afterEach(() => MSW.Server.resetHandlers(server))

  afterAll(() => MSW.Server.close(server))

  describe("get", () => {
    testPromise(
      "should return data for a response",
      () => {
        let value = {
          history: [{openingPrice: 1, closingPrice: 2}, {openingPrice: 2, closingPrice: 8}],
        }

        server->MSW.Server.use(
          MSW.REST.get(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [
                  ctx->MSW__REST__Context.statusWithText(200, "OK"),
                  ctx->MSW__REST__Context.json(Encode.stockPrice(value)),
                ],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ())
        ->Promise.then(json)
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

        server->MSW.Server.use(
          MSW.REST.post(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [
                  ctx->MSW__REST__Context.statusWithText(200, "OK"),
                  ctx->MSW__REST__Context.json(Encode.stockPrice(value)),
                ],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ~init={method: #POST}, ())
        ->Promise.then(json)
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

        server->MSW.Server.use(
          MSW.REST.put(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [
                  ctx->MSW__REST__Context.statusWithText(200, "OK"),
                  ctx->MSW__REST__Context.json(Encode.stockPrice(value)),
                ],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ~init={method: #PUT}, ())
        ->Promise.then(json)
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

        server->MSW.Server.use(
          MSW.REST.patch(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [
                  ctx->MSW__REST__Context.statusWithText(200, "OK"),
                  ctx->MSW__REST__Context.json(Encode.stockPrice(value)),
                ],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ~init={method: #PATCH}, ())
        ->Promise.then(json)
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
        server->MSW.Server.use(
          MSW.REST.delete(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [ctx->MSW__REST__Context.statusWithText(204, "No Content")],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ~init={method: #DELETE}, ())->Promise.thenResolve(
          response => {
            response["statusText"]->expect->toEqual("No Content")
          },
        )
      },
    )
  })
  describe("options", () => {
    testPromise(
      "should return data for a response",
      () => {
        server->MSW.Server.use(
          MSW.REST.options(
            #String("http://localhost:8080/"),
            (. _req, res, ctx) => {
              MSW__Raw__Response.res(
                res,
                [ctx->MSW__REST__Context.statusWithText(204, "No Content")],
              )
            },
          ),
        )

        fetch("http://localhost:8080/", ~init={method: #OPTIONS}, ())->Promise.thenResolve(
          resposne => {
            resposne["statusText"]->expect->toEqual("No Content")
          },
        )
      },
    )
  })

  describe("response", () => {
    testPromise(
      "should return error for networkError",
      () => {
        server->MSW.Server.use(
          MSW.REST.get(
            #String("http://localhost:8080/"),
            (. _req, res, _ctx) => {
              MSW__Raw__Response.networkError(res, "Oops")
            },
          ),
        )

        fetch("http://localhost:8080/", ())
        ->Promise.then(_ => Promise.resolve(Ok()))
        ->Promise.catch(error => Promise.resolve(Error(error)))
        ->Promise.thenResolve(value => value->Belt.Result.isError->expect->toBe(true))
      },
    )
  })
})
