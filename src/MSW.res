module Server = MSW__Server
module ServiceWorker = MSW__ServiceWorker
module GraphQL = MSW__GraphQL
module GraphQL_PPX = MSW__GraphQL_PPX
module REST = MSW__REST

/**
 * https://mswjs.io/docs/api/setup-worker
 */ @module("msw")
external setupWorker: unit => MSW__ServiceWorker.t = "setupWorker"

/**
 * https://mswjs.io/docs/api/setup-worker
 */ @module("msw") @variadic
external setupWorkerWithHandlers: array<MSW__Common.requestHandler> => MSW__ServiceWorker.t =
  "setupWorker"

/**
 * https://mswjs.io/docs/api/setup-server
 */ @module("msw/node")
external setupServer: unit => Server.t = "setupServer"

/**
 * https://mswjs.io/docs/api/setup-server
 */ @module("msw/node") @variadic
external setupServerWithHandlers: array<MSW__Common.requestHandler> => Server.t = "setupServer"
