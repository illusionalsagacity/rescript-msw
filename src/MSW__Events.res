/***
Provides bindings for MSW's life-cycle events API, allowing you to subscribe to various events during the request handling process.

https://mswjs.io/docs/api/life-cycle-events
*/

/**
An opaque type representing the event emitter instance provided by MSW (either from `setupServer` or `setupWorker`).
You can use this to subscribe to life-cycle events.

https://mswjs.io/docs/api/life-cycle-events
 */
type t

/*** Module containing types related to MSW life-cycle events. */
module Event = {
  /**
   The data structure passed to event listeners.
   It contains information about the request, and potentially the response or error if applicable to the event type.
   */
  type t = {
    request: Fetch.Request.t,
    requestId: string,
    response?: Fetch.Response.t,
    error?: Js.Exn.t,
  }
}

/**
The name of the event to listen to.

https://mswjs.io/docs/api/life-cycle-events#request-events
*/
type eventName = [
  | #"request:start"
  | #"request:match"
  | #"request:unhandled"
  | #"request:end"
  | #"response:mocked"
  | #"response:bypass"
  | #unhandledException
]

/**
Subscribes a listener function to a specific life-cycle event.

https://mswjs.io/docs/api/life-cycle-events#usage

```rescript
MSW.setupServer
->MSW.Server.events
->MSW.Events.on(#"request:start", ({request, _}) => {
  Js.Console.log2("Request started:", request->Fetch.Request.clone->Fetch.Request.url)
})
```
*/
@send
external on: (t, eventName, Event.t => unit) => unit = "on"

/**
An alias for `on`. Subscribes a listener function to a specific life-cycle event.

https://mswjs.io/docs/api/life-cycle-events#usage

```rescript
MSW.setupServer
->MSW.Server.events
->MSW.Events.addListener(#"request:start", ({request, _}) => {
  Js.Console.log2("Request started:", request->Fetch.Request.clone->Fetch.Request.url)
})
```
*/
@send
external addListener: (t, eventName, Event.t => unit) => unit = "addListener"

/**
Subscribes a listener function to a specific life-cycle event for a single occurrence.
After the listener is called once, it is automatically removed.

https://mswjs.io/docs/api/life-cycle-events#usage

```rescript
MSW.setupServer
->MSW.Server.events
->MSW.Events.once(#"request:start", ({request, _}) => {
  Js.Console.log2("Request started:", request->Fetch.Request.clone->Fetch.Request.url)
})
```
*/
@send
external once: (t, eventName, Event.t => unit) => unit = "once"

/**
Removes a previously subscribed listener function for a specific life-cycle event.

https://mswjs.io/docs/api/life-cycle-events#removelistener

```rescript
MSW.setupServer->MSW.Server.events->MSW.Events.removeListener(#"request:start", event => { ... })
```
*/
@send
external removeListener: (t, eventName, Event.t => unit) => unit = "removeListener"

/**
Removes all listeners from all life-cycle events.

https://mswjs.io/docs/api/life-cycle-events#removealllisteners

```rescript
MSW.setupServer->MSW.Server.events->MSW.Events.removeAllListeners()
```
*/
@send
external removeAllListeners: t => unit = "removeAllListeners"

/**
Removes all listeners for a specific life-cycle event.

https://mswjs.io/docs/api/life-cycle-events#removealllisteners

```rescript
MSW.setupServer->MSW.Server.events->MSW.Events.removeAllListenersForEvent(#"request:start")
```
*/
@send
external removeAllListenersForEvent: (t, eventName) => unit = "removeAllListeners"
