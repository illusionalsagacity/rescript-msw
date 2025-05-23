/***
This module defines common types used across the `rescript-msw` library.
*/

/**
This module type matches the shape of the generated operation module from `@reasonml-community/graphql-ppx` so we can generate a handler for it using the generated code.
It defines the necessary types and functions that `rescript-msw` expects for GraphQL operations when using this PPX.
*/
module type GraphQLPPXOperation = {
  module Raw: {
    type t
    type t_variables
  }
  type t
  type t_variables

  // this library does not actually need the query type, so we can eliminate any dependency on rescript-apollo-client by not including the property
  // let query: 'query
  let parse: Raw.t => t
  let serialize: t => Raw.t
  let serializeVariables: t_variables => Raw.t_variables
}

/**
Represents a request handler in MSW.

This is an opaque type that you'll create using functions from `MSW.Http`, `MSW.GraphQL`, etc.
and pass to a `MSW.ServiceWorker` or `MSW.Server` instance.

https://mswjs.io/docs/basics/request-handler
*/
type requestHandler
