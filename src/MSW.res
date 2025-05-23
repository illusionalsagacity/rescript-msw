module Delay = MSW__Delay
module Server = MSW__Server
module ServiceWorker = MSW__ServiceWorker
module GraphQL = MSW__GraphQL
module Http = MSW__Http
module HttpResponse = MSW__HttpResponse

/**
 * https://mswjs.io/docs/api/setup-worker
 */
@module("msw/browser")
external setupWorker: unit => MSW__ServiceWorker.t = "setupWorker"

/**
 * https://mswjs.io/docs/api/setup-worker
 */
@module("msw/browser")
@variadic
external setupWorkerWithHandlers: array<MSW__Common.requestHandler> => MSW__ServiceWorker.t =
  "setupWorker"

/**
 * https://mswjs.io/docs/api/setup-server
 */
@module("msw/node")
external setupServer: unit => Server.t = "setupServer"

/**
 * https://mswjs.io/docs/api/setup-server
 */
@module("msw/node")
@variadic
external setupServerWithHandlers: array<MSW__Common.requestHandler> => Server.t = "setupServer"

/**
https://mswjs.io/docs/api/passthrough
*/
@module("msw")
external passthrough: unit => MSW__HttpResponse.t = "passthrough"
