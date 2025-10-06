/***
Represents an MSW server instance, typically created using `MSW.setupServer()`.
This is used for mocking APIs in Node.js environments (e.g., during testing).

https://mswjs.io/docs/api/setup-server
*/
type t

/**
Specifies how unhandled requests should be treated by the server.

https://mswjs.io/docs/api/setup-server/listen#onunhandledrequest
*/
type onUnhandledRequest = [
  | #bypass
  | #warn
  | #error
]

/**
Options for the `listen` method of an MSW server instance.

https://mswjs.io/docs/api/setup-server/listen#options
*/
type listenOptions = {
  /** Defines how to handle requests that are not captured by any of the request handlers. */
  onUnhandledRequest: onUnhandledRequest,
}

/** Callback type with 0 arguments. 'ret is the return type. */
type cb0<'ret> = unit => 'ret
/** Callback type with 1 argument. 'arg1 is the type of the first argument, 'ret is the return type. */
type cb1<'arg1, 'ret> = 'arg1 => 'ret
/** Callback type with 2 arguments. 'arg1 and 'arg2 are argument types, 'ret is the return type. */
type cb2<'arg1, 'arg2, 'ret> = ('arg1, 'arg2) => 'ret
/** Callback type with 3 arguments. 'arg1, 'arg2, 'arg3 are argument types, 'ret is the return type. */
type cb3<'arg1, 'arg2, 'arg3, 'ret> = ('arg1, 'arg2, 'arg3) => 'ret
/** Callback type with 4 arguments. 'arg1, 'arg2, 'arg3, 'arg4 are argument types, 'ret is the return type. */
type cb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4) => 'ret
/** Callback type with 5 arguments. 'arg1, 'arg2, 'arg3, 'arg4, 'arg5 are argument types, 'ret is the return type. */
type cb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4, 'arg5) => 'ret
/** Callback type with 6 arguments. 'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6 are argument types, 'ret is the return type. */
type cb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
  'arg6,
) => 'ret

/** Asynchronous callback type with 0 arguments. 'ret is the return type of the promise. */
type asyncCb0<'ret> = unit => promise<'ret>
/** Asynchronous callback type with 1 argument. 'arg1 is the type of the first argument, 'ret is the return type of the promise. */
type asyncCb1<'arg1, 'ret> = 'arg1 => promise<'ret>
/** Asynchronous callback type with 2 arguments. 'arg1, 'arg2 are argument types, 'ret is the return type of the promise. */
type asyncCb2<'arg1, 'arg2, 'ret> = ('arg1, 'arg2) => promise<'ret>
/** Asynchronous callback type with 3 arguments. 'arg1, 'arg2, 'arg3 are argument types, 'ret is the return type of the promise. */
type asyncCb3<'arg1, 'arg2, 'arg3, 'ret> = ('arg1, 'arg2, 'arg3) => promise<'ret>
/** Asynchronous callback type with 4 arguments. 'arg1, 'arg2, 'arg3, 'arg4 are argument types, 'ret is the return type of the promise. */
type asyncCb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4) => promise<'ret>
/** Asynchronous callback type with 5 arguments. 'arg1, 'arg2, 'arg3, 'arg4, 'arg5 are argument types, 'ret is the return type of the promise. */
type asyncCb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
) => promise<'ret>
/** Asynchronous callback type with 6 arguments. 'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6 are argument types, 'ret is the return type of the promise. */
type asyncCb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
  'arg6,
) => promise<'ret>

/**
Scope the network interception to the given boundary. This can only be used with the `setupServer` API.

https://mswjs.io/docs/api/setup-server/boundary/

```rescript
let server = MSW.setupServerWithHandlers([
  MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Hello world")),
])

beforeEach(() => {
  server->MSW.Server.listen()
})

afterEach(() => {
  server->MSW.Server.close()
})

test("my test", MSW.Server.boundary(server, () => {
  // This code will be executed within the boundary
  server->MSW.Server.use(MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Inside the boundary")))
  Js.log("Inside the boundary")
})
```
*/
@send
external boundary: (t, cb0<'ret>) => cb0<'ret> = "boundary"

/**
Wraps an asynchronous callback function with MSW's boundary logic.

https://mswjs.io/docs/api/setup-server/boundary/

```rescript
let server = MSW.setupServerWithHandlers([
  MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Hello world")),
])

beforeEach(() => {
  server->MSW.Server.listen()
})

afterEach(() => {
  server->MSW.Server.close()
})

testAsync("my test", MSW.Server.boundaryAsync(server, async () => {
  // This code will be executed within the boundary
  server->MSW.Server.use(MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Inside the boundary")))
  Js.log("Inside the boundary")
})
```
*/
@send
external boundaryAsync: (t, asyncCb0<'ret>) => asyncCb0<'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary1: (t, cb1<'arg1, 'ret>) => cb1<'arg1, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync1: (t, asyncCb1<'arg1, 'ret>) => asyncCb1<'arg1, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary2: (t, cb2<'arg1, 'arg2, 'ret>) => cb2<'arg1, 'arg2, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync2: (t, asyncCb2<'arg1, 'arg2, 'ret>) => asyncCb2<'arg1, 'arg2, 'ret> =
  "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary3: (t, cb3<'arg1, 'arg2, 'arg3, 'ret>) => cb3<'arg1, 'arg2, 'arg3, 'ret> =
  "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync3: (
  t,
  asyncCb3<'arg1, 'arg2, 'arg3, 'ret>,
) => asyncCb3<'arg1, 'arg2, 'arg3, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary4: (
  t,
  cb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret>,
) => cb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync4: (
  t,
  asyncCb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret>,
) => asyncCb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary5: (
  t,
  cb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret>,
) => cb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync5: (
  t,
  asyncCb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret>,
) => asyncCb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary6: (
  t,
  cb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret>,
) => cb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundaryAsync6: (
  t,
  asyncCb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret>,
) => asyncCb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = "boundary"

/**
https://mswjs.io/docs/api/setup-server/listen

```rescript
let server = MSW.setupServer()
server->MSW.Server.listen()
```
*/
@send
external listen: t => unit = "listen"

/**
Starts the MSW server with specific options.

https://mswjs.io/docs/api/setup-server/listen#options

```rescript
let server = MSW.setupServer()
server->MSW.Server.listenWithOptions({onUnhandledRequest: #error})
```
*/
@send
external listenWithOptions: (t, listenOptions) => unit = "listen"

/**
Stops the MSW server, preventing it from intercepting further requests. Typically used in `afterEach` or `afterAll` hooks or global teardown.

```rescript
let server = MSW.setupServer()
server->MSW.Server.listen()
server->MSW.Server.close()
```
*/
@send
external close: t => unit = "close"

/**
Appends a new request handler to the existing list of handlers on the server.
This allows you to add or override mock definitions dynamically during your tests.

https://mswjs.io/docs/api/setup-server/use

```rescript
let server = MSW.setupServer()
server->MSW.Server.use(
  MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Hello world")),
)
```
*/
@send
external use: (t, MSW__Common.requestHandler) => unit = "use"

/**
Appends multiple new request handlers to the existing list of handlers on the server.
This allows you to add or override mock definitions dynamically during your tests.

https://mswjs.io/docs/api/setup-server/use

```rescript
let server = MSW.setupServer()
server->MSW.Server.useMany([
  MSW.Http.get(#URL("/api"), async _ => MSW.HttpResponse.text("Hello world")),
  MSW.Http.post(#URL("/api"), async _ => MSW.HttpResponse.text("Hello world")),
])
```
*/
@send
@variadic
external useMany: (t, array<MSW__Common.requestHandler>) => unit = "use"

/**
A wrapper for `use` that allows for chaining with the ReScript pipe operator (`->`).
After adding the handler, it returns the server instance.

Example:
```rescript
myServer
->MSW.Server.useChain(MSW.Http.get(...))
->MSW.Server.useChain(MSW.GraphQL.query(...))
```
*/
let useChain = (t, requestHandler) => {
  use(t, requestHandler)
  t
}

/**
Removes all runtime request handlers (those added with `server.use`) and reverts to the handlers provided initially to `setupServer`.
If no initial handlers were provided, this effectively removes all handlers.

https://mswjs.io/docs/api/setup-server/reset-handlers
*/
@send
external resetHandlers: t => unit = "resetHandlers"

/**
Removes all runtime request handlers and replaces them with a new set of specified handlers.
This is useful if you want to completely change the mock definitions for a specific test or group of tests.
If an empty array is provided, all handlers are removed, and no new ones are added.

https://mswjs.io/docs/api/setup-server/reset-handlers#providing-new-runtime-handlers
*/
@send
external resetHandlersWithReplace: (t, array<MSW__Common.requestHandler>) => unit = "resetHandlers"

/**
Restores the original request handlers that were provided to `setupServer` when it was called.
This effectively undoes any handlers added with `server.use()` or `server.resetHandlers()` with new handlers.
If `setupServer` was called without any handlers, this function will remove all current handlers.

https://mswjs.io/docs/api/setup-server/restore-handlers
*/
@send
external restoreHandlers: t => unit = "restoreHandlers"

/**
 * https://mswjs.io/docs/api/setup-server/list-handlers
 * This method accepts no arguments and returns a list of all handlers present on the server object. It’s primarily designed for debugging and introspection purposes.
 */
@send
external listHandlers: t => array<MSW__Common.requestHandler> = "listHandlers"

/**
Provides access to the life-cycle events emitter for this server instance.
You can use this to subscribe to events like request start, match, unhandled, etc.
https://mswjs.io/docs/api/life-cycle-events

Example:
```rescript
let server = MSW.setupServerWithHandlers([...])
server->MSW.Server.events->MSW.Events.on(#"request:start", event => {
  Js.Console.log2("Request started:", event.request->Fetch.Request.url)
})
```
*/
@get
external events: t => MSW__Events.t = "events"
