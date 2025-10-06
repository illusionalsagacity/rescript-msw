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
 * https://mswjs.io/docs/api/setup-worker/start#options
 */
type options = {
  serviceWorker?: serviceWorkerOptions,
  quiet?: bool,
  waitUntilReady?: bool,
  findWorker?: (string, string) => bool,
  onUnhandledRequest?: [#bypass | #warn | #error],
}

/**
 * https://mswjs.io/docs/api/setup-worker/start
 */
@send
external start: t => promise<unit> = "start"

/**
 * https://mswjs.io/docs/api/setup-worker/start
 */
@send
external startWithOptions: (t, options) => promise<unit> = "start"

/**
 * https://mswjs.io/docs/api/setup-worker/stop
 */
@send
external stop: t => unit = "stop"

/**
 * https://mswjs.io/docs/api/setup-worker/use
 */
@send
external use: (t, MSW__Common.requestHandler) => unit = "use"

/**
 * https://mswjs.io/docs/api/setup-worker/use
 */
@send
@variadic
external useMany: (t, array<MSW__Common.requestHandler>) => unit = "use"

/**
 * Wrapper to allow usage with ReScript pipes
 */
let useChain = (t, requestHandler) => {
  use(t, requestHandler)
  t
}

/**
 * https://mswjs.io/docs/api/setup-worker/reset-handlers
 */
@send
external resetHandlers: t => unit = "resetHandlers"

/**
 * https://mswjs.io/docs/api/setup-worker/reset-handlers
 */
@send
external resetHandlersWithReplace: (t, array<MSW__Common.requestHandler>) => unit = "resetHandlers"

/**
 * https://mswjs.io/docs/api/setup-worker/restore-handlers
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
 https://mswjs.io/docs/api/life-cycle-events
 */
@get
external events: t => MSW__Events.t = "events"
