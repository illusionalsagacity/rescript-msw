open Vitest

type response<'a> = {..} as 'a

type tick = {
  openingPrice: int,
  closingPrice: int,
}

type stockPrice = {history: array<tick>}

module Decode = {
  @warning("-4")
  let point = json =>
    switch json {
    | JSON.Object(dict{
        "openingPrice": JSON.Number(openingPrice),
        "closingPrice": JSON.Number(closingPrice),
      }) =>
      Ok({
        openingPrice: Int.fromFloat(openingPrice),
        closingPrice: Int.fromFloat(closingPrice),
      })
    | _ => Error("Invalid tick object")
    }

  // object(field => {
  //   openingPrice: field.required("openingPrice", int),
  //   closingPrice: field.required("closingPrice", int),
  // })

  @warning("-4")
  let stockPrice = json =>
    switch json {
    | JSON.Object(dict{"history": JSON.Array(historyJson)}) =>
      Ok({
        history: historyJson->Array.map(point)->Array.map(point => Result.getOrThrow(point)),
      })
    | _ => Error("Invalid stockPrice object")
    }
}

module Encode = {
  // open JsonCombinators.Json.Encode

  let tick = value => JSON.Object(
    dict{
      "openingPrice": value.openingPrice->Int.toFloat->JSON.Number,
      "closingPrice": value.closingPrice->Int.toFloat->JSON.Number,
    },
  )
  // object([("openingPrice", int(value.openingPrice)), ("closingPrice", int(value.closingPrice))])

  let arrayOfTicks = values => values->Array.map(tick)->JSON.Array

  let stockPrice = value => JSON.Object(dict{"history": arrayOfTicks(value.history)})
  // object([("history", arrayOfTicks(value.history))])
}

let url = "http://localhost:8080"

describe("MSW__Http", () => {
  open MSW

  describe("get", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
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

        let decoded = json->Decode.stockPrice->Result.getOrThrow
        ctx->expect(decoded)->Expect.toEqual(value)
      },
    )
  })

  describe("post", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
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
        let result = json->Decode.stockPrice->Result.getOrThrow

        ctx->expect(result)->Expect.toEqual(value)
      },
    )
  })

  describe("put", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
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
        let result = json->Decode.stockPrice->Result.getOrThrow
        ctx->expect(result)->Expect.toEqual(value)
      },
    )
  })

  describe("patch", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
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
        let result =
          json
          ->Decode.stockPrice
          ->Result.getOrThrow
        ctx->expect(result)->Expect.toEqual(value)
      },
    )
  })

  describe("delete", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
        MSWServerInstance.server->Server.use(
          Http.delete(
            #URL(url),
            async _options => {
              Http.Response.make(#Nullable(Undefined), {status: 204, statusText: "No Content"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #DELETE})
        let statusText = Fetch.Response.statusText(response)

        ctx->expect(statusText)->Expect.toEqual("No Content")
      },
    )
  })

  describe("options", () => {
    testAsync(
      "should return data for a response",
      async ctx => {
        MSWServerInstance.server->Server.use(
          Http.options(
            #URL(url),
            async _options => {
              Http.Response.make(#Nullable(Undefined), {status: 204, statusText: "No Content"})
            },
          ),
        )

        let response = await Fetch.fetch(url, {method: #OPTIONS})
        let statusText = Fetch.Response.statusText(response)
        ctx->expect(statusText)->Expect.toEqual("No Content")
      },
    )
  })

  describe("response", () => {
    testAsync(
      "should return error for networkError",
      async ctx => {
        MSWServerInstance.server->Server.use(
          Http.get(#URL(url), async _options => Http.Response.error()),
        )

        let response = Fetch.fetch(url, {method: #GET})

        await expect(ctx, response)
        ->Expect.Promise.rejects
        ->Expect.Promise.toThrowError(~message="Failed to fetch")
      },
    )
  })
})
