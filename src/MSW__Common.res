// this probably can be turned into the functor that GraphQL_PPX uses
module type GraphQLOperation = {
  module Raw: {
    type t
    type t_variables
  }
  type t
  type t_variables

  let query: ApolloClient.GraphQL_PPX.templateTagReturnType
  let parse: Raw.t => t
  let serialize: t => Raw.t
  let serializeVariables: t_variables => Raw.t_variables
}

type requestHandler
