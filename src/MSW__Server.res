type t

type onUnhandledRequest = [#bypass | #warn | #error]

/**
 * https://mswjs.io/docs/api/setup-server/listen#options
 */
type listenOptions = {onUnhandledRequest: onUnhandledRequest}

type cb0<'ret> = unit => 'ret
type cb1<'arg1, 'ret> = 'arg1 => 'ret
type cb2<'arg1, 'arg2, 'ret> = ('arg1, 'arg2) => 'ret
type cb3<'arg1, 'arg2, 'arg3, 'ret> = ('arg1, 'arg2, 'arg3) => 'ret
type cb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4) => 'ret
type cb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4, 'arg5) => 'ret
type cb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
  'arg6,
) => 'ret

type asyncCb0<'ret> = unit => promise<'ret>
type asyncCb1<'arg1, 'ret> = 'arg1 => promise<'ret>
type asyncCb2<'arg1, 'arg2, 'ret> = ('arg1, 'arg2) => promise<'ret>
type asyncCb3<'arg1, 'arg2, 'arg3, 'ret> = ('arg1, 'arg2, 'arg3) => promise<'ret>
type asyncCb4<'arg1, 'arg2, 'arg3, 'arg4, 'ret> = ('arg1, 'arg2, 'arg3, 'arg4) => promise<'ret>
type asyncCb5<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
) => promise<'ret>
type asyncCb6<'arg1, 'arg2, 'arg3, 'arg4, 'arg5, 'arg6, 'ret> = (
  'arg1,
  'arg2,
  'arg3,
  'arg4,
  'arg5,
  'arg6,
) => promise<'ret>

/**
  https://mswjs.io/docs/api/setup-server/boundary/
 */
@send
external boundary: (t, cb0<'ret>) => cb0<'ret> = "boundary"

/**
  https://mswjs.io/docs/api/setup-server/boundary/
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
