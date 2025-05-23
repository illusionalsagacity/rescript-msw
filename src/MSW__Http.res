/***
Provides bindings for MSW's HTTP request handlers (`http.*`).

These functions allow you to define mock responses for specific HTTP methods and URL patterns.

https://mswjs.io/docs/api/http
*/
module Response = MSW__HttpResponse

/**
Options passed to an HTTP resolver function.

request: The incoming `Fetch.Request.t` instance.
cookies: A dictionary of cookies parsed from the request.
params: A dictionary of parameters extracted from the request URL path if a path with parameters was used (e.g., `/user/:id`). For example, if the path is `/user/:id` and the request is to `/user/123`, `params` will be `{"id": "123"}`.
*/
type resolverOptions = {
  request: Fetch.Request.t,
  cookies: Js.Dict.t<string>,
  params: Js.Dict.t<string>,
}

/**
Creates a handler that intercepts any HTTP request method for the given URL pattern.

https://mswjs.io/docs/api/http/all

```rescript
MSW.Http.all(
  #URL("/api/"),
  async ({ request, cookies, params }) => {
    MSW.HttpResponse.text("Intercepted any method", {status: 200})
  }
)
```
*/
@module("msw")
@scope("http")
external all: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "all"

/**
Creates a handler that intercepts any HTTP request method, with explicit options.

https://mswjs.io/docs/api/http/all
*/
@deprecated("Use `all` with `~options` parameter instead")
@module("msw")
@scope("http")
external allWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "all"

/**
Creates a handler for HTTP HEAD requests.

https://mswjs.io/docs/api/http/head

Example:
```rescript
MSW.Http.head(
  #URL("/api/health"),
  async ({ request, cookies, params }) => {
    MSW.HttpResponse.text("", {status: 200})
  }
)
```
*/
@module("msw")
@scope("http")
external head: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "head"

/**
Creates a handler for HTTP HEAD requests, with explicit options.
*/
@deprecated("Use `head` with the optional `~options` parameter instead")
@module("msw")
@scope("http")
external headWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "head"

/**
Creates a handler for HTTP GET requests.

https://mswjs.io/docs/api/http/get

Example:
```rescript
MSW.Http.get(
  #URL("/user"),
  async ({ request, cookies, params }) => {
    [("name", Js.Json.string("John"))]
    ->Js.Dict.fromArray
    ->MSW.HttpResponse.json({status: 200})
  }
)
```
*/
@module("msw")
@scope("http")
external get: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "get"

/**
Creates a handler for HTTP GET requests, with explicit options.
*/
@deprecated("Use `get` with the optional `~options` parameter instead")
@module("msw")
@scope("http")
external getWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "get"

/**
Creates a handler for HTTP POST requests.

https://mswjs.io/docs/api/http/post

Example:
```rescript
MSW.Http.post(
  #URL("/api/users"),
  async ({ request, cookies, params }) => {
    [("id", Js.Json.string("123")), ("created", Js.Json.boolean(true))]
    ->Js.Dict.fromArray
    ->MSW.HttpResponse.json({status: 201})
  }
)
```
*/
@module("msw")
@scope("http")
external post: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "post"

/**
Creates a handler for HTTP POST requests, with explicit options.
*/
@deprecated("Use `post` with the optional `~options` parameter instead.")
@module("msw")
@scope("http")
external postWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "post"

/**
Creates a handler for HTTP PUT requests.
https://mswjs.io/docs/api/http/put

Example:
```rescript
MSW.Http.put(
  #URL("/api/users/:id"),
  async ({ request, cookies, params }) => {
    [("id", Js.Json.string(params->Js.Dict.get("id")->Belt.Option.getWithDefault("unknown"))), ("updated", Js.Json.boolean(true))]
    ->Js.Dict.fromArray
    ->MSW.HttpResponse.json({status: 200})
  }
)
```
*/
@module("msw")
@scope("http")
external put: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "put"

/**
Creates a handler for HTTP PUT requests, with explicit options.
*/
@deprecated("Use `put` with the optional `~options` parameter instead.")
@module("msw")
@scope("http")
external putWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "put"

/**
Creates a handler for HTTP PATCH requests.

https://mswjs.io/docs/api/http/patch

Example:
```rescript
MSW.Http.patch(
  #URL("/api/users/:id"),
  async ({ request, cookies, params }) => {
    [
      ("id", Js.Json.string(params->Js.Dict.get("id")->Belt.Option.getWithDefault("unknown"))),
      ("patched", Js.Json.boolean(true))
    ]
    ->Js.Dict.fromArray
    ->MSW.HttpResponse.json({status: 200})
  }
)
```
*/
@module("msw")
@scope("http")
external patch: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "patch"

/**
Creates a handler for HTTP PATCH requests, with explicit options.
*/
@deprecated("Use `patch` with the optional `~options` parameter instead")
@module("msw")
@scope("http")
external patchWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "patch"

/**
Creates a handler for HTTP DELETE requests.

https://mswjs.io/docs/api/http/delete

Example:
```rescript
MSW.Http.delete(
  #URL("/api/users/:id"),
  async ({ request, cookies, params }) => {
    MSW.HttpResponse.text("", {status: 204})
  }
)
```
*/
@module("msw")
@scope("http")
external delete: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "delete"

/**
Creates a handler for HTTP DELETE requests, with explicit options.
*/
@deprecated("Use `delete` with the optional `~options` parameter instead.")
@module("msw")
@scope("http")
external deleteWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "delete"

/**
Creates a handler for HTTP OPTIONS requests.

https://mswjs.io/docs/api/http/options

Example:
```rescript
MSW.Http.options(
  #URL("/api/users"),
  async ({ request, cookies, params }) => {
    MSW.HttpResponse.text("", {status: 200, headers: [("Allow", "GET,POST,PUT,DELETE")]})
  }
)
```
*/
@module("msw")
@scope("http")
external options: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "options"

/**
Creates a handler for HTTP OPTIONS requests, with explicit options.
*/
@deprecated("Use `options` with the optional `~options` parameter instead.")
@module("msw")
@scope("http")
external optionsWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t) | #URLObject(Url.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "options"
