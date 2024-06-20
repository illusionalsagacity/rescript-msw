/***
 https://mswjs.io/docs/api/life-cycle-events
 */
type t

module Event = {
  type t = {
    request: Fetch.Request.t,
    requestId: string,
    response?: Fetch.Response.t,
    error?: Js.Exn.t,
  }
}

@send
external on: (
  t,
  [
    | #"request:start"
    | #"request:match"
    | #"request:unhandled"
    | #"request:end"
    | #"response:mocked"
    | #"response:bypass"
    | #unhandledException
  ],
  Event.t => unit,
) => unit = "on"

@send
external addListener: (
  t,
  [
    | #"request:start"
    | #"request:match"
    | #"request:unhandled"
    | #"request:end"
    | #"response:mocked"
    | #"response:bypass"
    | #unhandledException
  ],
  Event.t => unit,
) => unit = "addListener"

@send
external once: (
  t,
  [
    | #"request:start"
    | #"request:match"
    | #"request:unhandled"
    | #"request:end"
    | #"response:mocked"
    | #"response:bypass"
    | #unhandledException
  ],
  Event.t => unit,
) => unit = "once"

@send
external removeListener: (
  t,
  [
    | #"request:start"
    | #"request:match"
    | #"request:unhandled"
    | #"request:end"
    | #"response:mocked"
    | #"response:bypass"
    | #unhandledException
  ],
  Event.t => unit,
) => unit = "removeListener"

@send
external removeAllListeners: t => unit = "removeAllListeners"

@send
external removeAllListenersForEvent: (
  t,
  [
    | #"request:start"
    | #"request:match"
    | #"request:unhandled"
    | #"request:end"
    | #"response:mocked"
    | #"response:bypass"
    | #unhandledException
  ],
) => unit = "removeAllListeners"
