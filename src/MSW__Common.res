module type GraphQLOperation = {
  module Raw: {
    type t
    type t_variables
  }
  type t
  type t_variables

  let parse: Raw.t => t
  let serialize: t => Raw.t
  let serializeVariables: t_variables => Raw.t_variables
}

type requestHandler
type responseTransformer = MSW__Raw__Response.t => MSW__Raw__Response.t
type responseResolver = array<responseTransformer> => MSW__Raw__Response.t
type responseBuilder = array<responseTransformer>
