/**
 * This module exists to wrap the MSW GraphQL functions for use with graphql_ppx.
 */
module Request = MSW__GraphQL__Request

type responseBuilder = MSW__Common.responseBuilder

type requestBody<'variables> = {
  query: string,
  operationName: string,
  variables: 'variables,
}

type response = {
  res: unit => responseBuilder,
  once: unit => responseBuilder,
  networkError: string => responseBuilder,
}

type handler<'requestBody, 'data, 'variables, 'extensions> = (
  Request.t<'requestBody, 'variables>,
  response,
  MSW__Context.WrappedGraphQL.t<'data, 'extensions>,
) => responseBuilder

type callFunc = Response | Once | NetworkError(string)

let query:
  type data variables. (
    module(MSW__Common.GraphQLOperation with type t = data and type t_variables = variables),
    [#String(string) | #RegExp(Js.Re.t)],
    handler<requestBody<variables>, data, variables, {..}>,
  ) => MSW__Common.requestHandler =
  (module(Operation), name, handler) => {
    MSW__GraphQL.query(name, (. req, _res, ctx) => {
      let func = ref(Response)
      let wrappedContext = MSW__Context.WrappedGraphQL.wrap(module(Operation), ctx)
      let wrappedRes = {
        res: () => {
          func := Response
          []
        },
        once: () => {
          func := Once
          []
        },
        networkError: message => {
          func := NetworkError(message)
          []
        },
      }
      let transformers = handler(req, wrappedRes, wrappedContext)
      switch func.contents {
      | Response => MSW__ResponseResolver.response(transformers)
      | Once => MSW__ResponseResolver.once(transformers)
      | NetworkError(message) => MSW__ResponseResolver.networkError(message)
      }
    })
  }

let mutation:
  type data variables. (
    module(MSW__Common.GraphQLOperation with type t = data and type t_variables = variables),
    [#String(string) | #RegExp(Js.Re.t)],
    handler<requestBody<variables>, data, variables, {..}>,
  ) => MSW__Common.requestHandler =
  (module(Operation), name, handler) => {
    MSW__GraphQL.mutation(name, (. req, _res, ctx) => {
      let func = ref(Response)
      let wrappedContext = MSW__Context.WrappedGraphQL.wrap(module(Operation), ctx)
      let wrappedRes = {
        res: () => {
          func := Response
          []
        },
        once: () => {
          func := Once
          []
        },
        networkError: message => {
          func := NetworkError(message)
          []
        },
      }
      let transformers = handler(req, wrappedRes, wrappedContext)
      switch func.contents {
      | Response => MSW__ResponseResolver.response(transformers)
      | Once => MSW__ResponseResolver.once(transformers)
      | NetworkError(message) => MSW__ResponseResolver.networkError(message)
      }
    })
  }

let operation:
  type data variables. (
    module(MSW__Common.GraphQLOperation with type t = data and type t_variables = variables),
    [#String(string) | #RegExp(Js.Re.t)],
    handler<requestBody<variables>, data, variables, {..}>,
  ) => MSW__Common.requestHandler =
  (module(Operation), name, handler) => {
    MSW__GraphQL.operation(name, (. req, _res, ctx) => {
      let func = ref(Response)
      let wrappedContext = MSW__Context.WrappedGraphQL.wrap(module(Operation), ctx)
      let wrappedRes = {
        res: () => {
          func := Response
          []
        },
        once: () => {
          func := Once
          []
        },
        networkError: message => {
          func := NetworkError(message)
          []
        },
      }
      let transformers = handler(req, wrappedRes, wrappedContext)
      switch func.contents {
      | Response => MSW__ResponseResolver.response(transformers)
      | Once => MSW__ResponseResolver.once(transformers)
      | NetworkError(message) => MSW__ResponseResolver.networkError(message)
      }
    })
  }
