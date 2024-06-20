/**
This module type matches the shape of the generated operation module from `@reasonml-community/graphql-ppx` so we can generate a handler for it using the generated code.
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
 The MSW request handler
 */
type requestHandler
