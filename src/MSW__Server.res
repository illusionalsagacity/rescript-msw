type t

type onUnhandledRequest = [#bypass | #warn | #error]

/**
 * https://mswjs.io/docs/api/setup-server/listen#options
 */
type listenOptions = {onUnhandledRequest: onUnhandledRequest}

/**
 * https://mswjs.io/docs/api/setup-server/listen
 */
@send
external listen: t => unit = "listen"

/**
 * https://mswjs.io/docs/api/setup-server/listen
 */
@send
external listenWithOptions: (t, listenOptions) => unit = "listen"

/**
 * https://mswjs.io/docs/api/setup-server/close
 */
@send
external close: t => unit = "close"

/**
 * https://mswjs.io/docs/api/setup-server/use
 */
@send
external use: (t, MSW__Common.requestHandler) => unit = "use"

/**
 * https://mswjs.io/docs/api/setup-server/use
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
 * https://mswjs.io/docs/api/setup-server/reset-handlers
 */
@send
external resetHandlers: t => unit = "resetHandlers"

/**
 * https://mswjs.io/docs/api/setup-server/reset-handlers
 */
@send
external resetHandlersWithReplace: (t, array<MSW__Common.requestHandler>) => unit = "resetHandlers"

/**
 * https://mswjs.io/docs/api/setup-server/restore-handlers
 */
@send
external restoreHandlers: t => unit = "restoreHandlers"

/**
 * https://mswjs.io/docs/api/setup-server/print-handlers
 */
@send
external printHandlers: t => unit = "printHandlers"
