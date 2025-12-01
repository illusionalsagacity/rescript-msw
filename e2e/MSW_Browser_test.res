/**
 * Example browser tests demonstrating MSW usage with the service worker.
 *
 * These tests run in a real browser environment using Vitest browser mode.
 * MSW intercepts fetch requests via a service worker, enabling realistic
 * integration testing without a running backend.
 */
open Vitest

// Example response types
type user = {
  id: int,
  name: string,
  email: string,
}

type post = {
  id: int,
  title: string,
  body: string,
}

// JSON encoding helpers
module Encode = {
  let user = (u: user) => JSON.Object(
    dict{
      "id": u.id->Int.toFloat->JSON.Number,
      "name": u.name->JSON.String,
      "email": u.email->JSON.String,
    },
  )

  let post = (p: post) => JSON.Object(
    dict{
      "id": p.id->Int.toFloat->JSON.Number,
      "title": p.title->JSON.String,
      "body": p.body->JSON.String,
    },
  )

  let posts = (posts: array<post>) => posts->Array.map(post)->JSON.Array
}

// JSON decoding helpers
module Decode = {
  @warning("-4")
  let user = json =>
    switch json {
    | JSON.Object(dict{
        "id": JSON.Number(id),
        "name": JSON.String(name),
        "email": JSON.String(email),
      }) =>
      Ok({id: Int.fromFloat(id), name, email})
    | _ => Error("Invalid user object")
    }

  @warning("-4")
  let post = json =>
    switch json {
    | JSON.Object(dict{
        "id": JSON.Number(id),
        "title": JSON.String(title),
        "body": JSON.String(body),
      }) =>
      Ok({id: Int.fromFloat(id), title, body})
    | _ => Error("Invalid post object")
    }

  @warning("-4")
  let posts = json =>
    switch json {
    | JSON.Array(arr) =>
      arr
      ->Array.filterMap(p =>
        switch post(p) {
        | Ok(v) => Some(v)
        | Error(_) => None
        }
      )
      ->Ok
    | _ => Error("Expected array")
    }
}

let baseUrl = "https://api.example.com"

describe("MSW Browser - HTTP Mocking", () => {
  open MSW

  describe("GET requests", () => {
    testAsync("mocks a simple GET request", async ctx => {
      let expectedUser = {id: 1, name: "John Doe", email: "john@example.com"}

      // Add a handler for this specific test
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(
          #URL(`${baseUrl}/users/1`),
          async _info => {
            Encode.user(expectedUser)->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )

      // Make a real fetch request - the service worker intercepts it
      let response = await Fetch.fetch(`${baseUrl}/users/1`, {method: #GET})
      let json = await Fetch.Response.json(response)
      let user = json->Decode.user->Result.getOrThrow

      ctx->expect(user.id)->Expect.toEqual(1)
      ctx->expect(user.name)->Expect.toEqual("John Doe")
      ctx->expect(user.email)->Expect.toEqual("john@example.com")
    })

    testAsync("mocks a GET request returning an array", async ctx => {
      let expectedPosts = [
        {id: 1, title: "First Post", body: "Hello world"},
        {id: 2, title: "Second Post", body: "More content"},
      ]

      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(
          #URL(`${baseUrl}/posts`),
          async _info => {
            Encode.posts(expectedPosts)->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )

      let response = await Fetch.fetch(`${baseUrl}/posts`, {method: #GET})
      let json = await Fetch.Response.json(response)
      let posts = json->Decode.posts->Result.getOrThrow

      ctx->expect(posts->Array.length)->Expect.toEqual(2)
      ctx->expect((posts->Array.getUnsafe(0)).title)->Expect.toEqual("First Post")
    })
  })

  describe("POST requests", () => {
    testAsync("mocks a POST request with request body access", async ctx => {
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.post(
          #URL(`${baseUrl}/users`),
          async info => {
            // Access the request body
            let body = await info.request->Fetch.Request.json
            @warning("-4")
            let name = switch body {
            | JSON.Object(dict{"name": JSON.String(n)}) => n
            | _ => "Unknown"
            }

            // Return a created user with the provided name
            let createdUser = {id: 42, name, email: `${name->String.toLowerCase}@example.com`}
            Encode.user(createdUser)->Http.Response.json({status: 201, statusText: "Created"})
          },
        ),
      )

      let response = await Fetch.fetch(
        `${baseUrl}/users`,
        {
          method: #POST,
          headers: Fetch.Headers.fromObject({"Content-Type": "application/json"}),
          body: Fetch.Body.string(`{"name": "Jane Smith"}`),
        },
      )
      let json = await Fetch.Response.json(response)
      let user = json->Decode.user->Result.getOrThrow

      ctx->expect(response->Fetch.Response.status)->Expect.toEqual(201)
      ctx->expect(user.id)->Expect.toEqual(42)
      ctx->expect(user.name)->Expect.toEqual("Jane Smith")
    })
  })

  describe("Error responses", () => {
    testAsync("mocks a 404 Not Found response", async ctx => {
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(
          #URL(`${baseUrl}/users/999`),
          async _info => {
            JSON.Object(dict{"error": "User not found"->JSON.String})
            ->Http.Response.json({status: 404, statusText: "Not Found"})
          },
        ),
      )

      let response = await Fetch.fetch(`${baseUrl}/users/999`, {method: #GET})

      ctx->expect(response->Fetch.Response.status)->Expect.toEqual(404)
      ctx->expect(response->Fetch.Response.ok)->Expect.toEqual(false)
    })

    testAsync("mocks a network error", async ctx => {
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(#URL(`${baseUrl}/network-error`), async _info => Http.Response.error()),
      )

      let fetchPromise = Fetch.fetch(`${baseUrl}/network-error`, {method: #GET})

      await expect(ctx, fetchPromise)
      ->Expect.Promise.rejects
      ->Expect.Promise.toThrowError(~message="Failed to fetch")
    })
  })

  describe("URL parameters", () => {
    testAsync("accesses URL path parameters", async ctx => {
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(
          #URL(`${baseUrl}/users/:userId/posts/:postId`),
          async info => {
            // Access path parameters from the request
            let userId = info.params->Dict.get("userId")->Option.getOr("0")
            let postId = info.params->Dict.get("postId")->Option.getOr("0")

            let post = {
              id: Int.fromString(postId)->Option.getOr(0),
              title: `Post by user ${userId}`,
              body: "Dynamic content",
            }
            Encode.post(post)->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )

      let response = await Fetch.fetch(`${baseUrl}/users/5/posts/10`, {method: #GET})
      let json = await Fetch.Response.json(response)
      let post = json->Decode.post->Result.getOrThrow

      ctx->expect(post.id)->Expect.toEqual(10)
      ctx->expect(post.title)->Expect.toEqual("Post by user 5")
    })
  })

  describe("Response delays", () => {
    testAsync("simulates network latency", async ctx => {
      MSWBrowserInstance.worker->ServiceWorker.use(
        Http.get(
          #URL(`${baseUrl}/slow`),
          async _info => {
            // Simulate a slow response
            await MSW.Delay.delay(100)
            JSON.Object(dict{"message": "Delayed response"->JSON.String})
            ->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )

      let startTime = Date.now()
      let _response = await Fetch.fetch(`${baseUrl}/slow`, {method: #GET})
      let endTime = Date.now()

      // Verify the delay occurred (with some tolerance)
      ctx->expect(endTime -. startTime)->Expect.Float.toBeGreaterThanOrEqual(100.0)
    })
  })

  describe("Handler chaining", () => {
    testAsync("adds multiple handlers using useChain", async ctx => {
      // Demonstrate the fluent API for adding multiple handlers
      MSWBrowserInstance.worker
      ->ServiceWorker.useChain(
        Http.get(
          #URL(`${baseUrl}/resource-a`),
          async _info => {
            JSON.Object(dict{"type": "A"->JSON.String})
            ->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )
      ->ServiceWorker.useChain(
        Http.get(
          #URL(`${baseUrl}/resource-b`),
          async _info => {
            JSON.Object(dict{"type": "B"->JSON.String})
            ->Http.Response.json({status: 200, statusText: "OK"})
          },
        ),
      )
      ->ignore

      let responseA = await Fetch.fetch(`${baseUrl}/resource-a`, {method: #GET})
      let responseB = await Fetch.fetch(`${baseUrl}/resource-b`, {method: #GET})

      ctx->expect(responseA->Fetch.Response.ok)->Expect.toEqual(true)
      ctx->expect(responseB->Fetch.Response.ok)->Expect.toEqual(true)
    })
  })
})

describe("MSW Browser - Passthrough", () => {
  testAsync("allows requests to pass through to the network", async ctx => {
    // This test demonstrates passthrough - requests go to the real network
    // Note: This will fail if the URL doesn't exist, which is expected behavior
    MSWBrowserInstance.worker->MSW.ServiceWorker.use(
      MSW.Http.get(
        #URL("https://httpbin.org/get"),
        async _info => {
          // Let this request through to the actual server
          MSW.passthrough()
        },
      ),
    )

    let response = await Fetch.fetch("https://httpbin.org/get", {method: #GET})

    // httpbin.org returns information about the request
    ctx->expect(response->Fetch.Response.ok)->Expect.toEqual(true)
  })
})
