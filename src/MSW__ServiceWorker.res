type t

type serviceWorkerRegistrationOptions = {scope: string}

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
  findWorker?: (. string, string) => bool,
  onUnhandledRequest?: [#bypass | #warn | #error],
}

/**
 * https://mswjs.io/docs/api/setup-worker/start
 */
@send
external start: t => unit = "start"

/**
 * https://mswjs.io/docs/api/setup-worker/start
 */
@send
external startWithOptions: (t, options) => unit = "start"

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
 * https://mswjs.io/docs/api/setup-worker/print-handlers
 * an alias of "printHandlers" for easier migration
 */
@send
external listHandlers: t => unit = "printHandlers"

/**
 https://mswjs.io/docs/api/life-cycle-events
 */
@get
external events: (t) => MSW__Events.t = "events"