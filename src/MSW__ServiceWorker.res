/***
Represents an MSW service worker instance created using `MSW.setupWorker()`.

https://mswjs.io/docs/api/setup-worker
*/
type t

type swType = [#classic | #"module"]
type updateViaCache = [#all | #none | #imports]

/** Options for service worker registration. */
type serviceWorkerRegistrationOptions = {
  scope?: string,
  @as("type") type_?: swType,
  updateViaCache?: updateViaCache,
}

/**
Options for configuring the service worker used by MSW.

https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerContainer/register#options
*/
type serviceWorkerOptions = {
  url?: string,
  options?: serviceWorkerRegistrationOptions,
}

/**
Options for the `start` method of an MSW service worker instance.

https://mswjs.io/docs/api/setup-worker/start#options
*/
type options = {
  serviceWorker?: serviceWorkerOptions,
  quiet?: bool,
  waitUntilReady?: bool,
  findWorker?: (string, string) => bool,
  onUnhandledRequest?: [#bypass | #warn | #error],
}

/**
Starts the MSW service worker, making it intercept requests in the browser.
Returns a promise that resolves when the worker is ready (or immediately if `waitUntilReady` is false).

https://mswjs.io/docs/api/setup-worker/start
*/
@send
external start: t => promise<unit> = "start"

/**
Starts the MSW service worker with specific options.
Returns a promise that resolves when the worker is ready.

https://mswjs.io/docs/api/setup-worker/start#options
*/
@send
external startWithOptions: (t, options) => promise<unit> = "start"

/**
Stops the MSW service worker, unregistering it and preventing it from intercepting further requests.

https://mswjs.io/docs/api/setup-worker/stop
*/
@send
external stop: t => unit = "stop"

/**
Appends a new request handler to the existing list of handlers on the service worker.
This allows you to add or override mock definitions dynamically in the browser.

https://mswjs.io/docs/api/setup-worker/use
*/
@send
external use: (t, MSW__Common.requestHandler) => unit = "use"

/**
Appends multiple new request handlers to the existing list of handlers on the service worker.

https://mswjs.io/docs/api/setup-worker/use
*/
@send
@variadic
external useMany: (t, array<MSW__Common.requestHandler>) => unit = "use"

/**
 A wrapper for `use` that allows for chaining with the ReScript pipe operator (`->`).
 After adding the handler, it returns the worker instance.
 
 ### Example

 ```rescript
 myWorker
 ->MSW.ServiceWorker.useChain(MSW.Http.get(...))
 ->MSW.ServiceWorker.useChain(MSW.GraphQL.query(...))
 ```
 */
let useChain = (t, requestHandler) => {
  use(t, requestHandler)
  t
}

/**
Removes all runtime request handlers (those added with `worker.use`) and reverts to the handlers provided initially to `setupWorker`.
If no initial handlers were provided, this effectively removes all handlers.
*/
@send
external resetHandlers: t => unit = "resetHandlers"

/**
Removes all runtime request handlers and replaces them with a new set of specified handlers.
This is useful if you want to completely change the mock definitions for a specific scenario in the browser.

https://mswjs.io/docs/api/setup-worker/reset-handlers#providing-new-runtime-handlers
*/
@send
external resetHandlersWithReplace: (t, array<MSW__Common.requestHandler>) => unit = "resetHandlers"

/**
Restores the original request handlers that were provided to `setupWorker` when it was called.
This effectively undoes any handlers added with `worker.use()` or `worker.resetHandlers()` with new handlers.
If `setupWorker` was called without any handlers, this function will remove all current handlers.

https://mswjs.io/docs/api/setup-worker/restore-handlers
*/
@send
external restoreHandlers: t => unit = "restoreHandlers"

/**
 * https://mswjs.io/docs/api/setup-worker/list-handlers
 * This method accepts no arguments and returns a list of all handlers present on the worker object. It’s primarily designed for debugging and introspection purposes.
 */
@send
external listHandlers: t => array<MSW__Common.requestHandler> = "listHandlers"

/**
Provides access to the life-cycle events emitter for this service worker instance.
You can use this to subscribe to events like request start, match, unhandled, etc., in the browser.

https://mswjs.io/docs/api/life-cycle-events

Example:
```rescript
let worker = MSW.setupWorkerWithHandlers([...])
worker->MSW.ServiceWorker.events->MSW.Events.on(#"request:start", event => {
  Js.Console.log2("Request started:", event.request->Fetch.Request.url)
})
```
*/
@get
external events: t => MSW__Events.t = "events"
