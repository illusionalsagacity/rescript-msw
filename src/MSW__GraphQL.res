/***
 * https://mswjs.io/docs/api/graphql
 */

/**
 * https://mswjs.io/docs/api/graphql/query
 */ @module("msw") @scope("graphql")
external query: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  (
    . MSW__GraphQL__Request.t<'requestBody, 'variables>,
    MSW__Raw__Response.t,
    MSW__GraphQL__Context.t<'data, {..}>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "query"

/**
 * https://mswjs.io/docs/api/graphql/mutation
 */ @module("msw") @scope("graphql")
external mutation: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  (
    . MSW__GraphQL__Request.t<'requestBody, 'variables>,
    MSW__Raw__Response.t,
    MSW__GraphQL__Context.t<'data, {..}>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "mutation"

/**
 * https://mswjs.io/docs/api/graphql/operation
 */ @module("msw") @scope("graphql")
external operation: (
  (
    . MSW__GraphQL__Request.t<'requestBody, 'variables>,
    MSW__Raw__Response.t,
    MSW__GraphQL__Context.t<'data, {..}>,
  ) => MSW__MockedResponse.t
) => MSW__Common.requestHandler = "operation"

// Not yet implemented: https://mswjs.io/docs/api/graphql/link
