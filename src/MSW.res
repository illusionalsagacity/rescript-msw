/***
Provides access to the MSW (Mock Service Worker) library functionality.

This module re-exports functionalities from more specific modules like `MSW.Delay`, `MSW.Server`, etc.
*/

module Delay = MSW__Delay
module Server = MSW__Server
module ServiceWorker = MSW__ServiceWorker
module GraphQL = MSW__GraphQL
module Http = MSW__Http
module HttpResponse = MSW__HttpResponse

/**
Sets up a new service worker instance with the given request handlers.
Ideal for client-side mocking in browsers.

https://mswjs.io/docs/api/setup-worker

Returns a new `MSW.ServiceWorker.t` instance.
*/
@module("msw")
external setupWorker: unit => MSW__ServiceWorker.t = "setupWorker"

/**
Sets up a new service worker instance with the given request handlers.
Ideal for client-side mocking in browsers.

https://mswjs.io/docs/api/setup-worker

Returns a new `MSW.ServiceWorker.t` instance.
*/
@module("msw")
@variadic
external setupWorkerWithHandlers: array<MSW__Common.requestHandler> => MSW__ServiceWorker.t =
  "setupWorker"

/**
Sets up a new server instance for Node.js environments.
Useful for API mocking in tests or development servers.

https://mswjs.io/docs/api/setup-server

Returns a new `MSW.Server.t` instance.
*/
@module("msw/node")
external setupServer: unit => Server.t = "setupServer"

/**
Sets up a new server instance with the given request handlers for Node.js environments.
Useful for API mocking in tests or development servers.

https://mswjs.io/docs/api/setup-server

Returns a new `MSW.Server.t` instance.
*/
@module("msw/node")
@variadic
external setupServerWithHandlers: array<MSW__Common.requestHandler> => Server.t = "setupServer"

/**
A special response that instructs MSW to bypass its own handlers and perform the request as-is.
Useful for selectively mocking requests while allowing others to proceed normally.

https://mswjs.io/docs/api/passthrough

returns An `MSW.HttpResponse.t` that signals a passthrough.
*/
@module("msw")
external passthrough: unit => MSW__HttpResponse.t = "passthrough"
