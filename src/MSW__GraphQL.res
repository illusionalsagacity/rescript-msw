/***
 * https://mswjs.io/docs/api/graphql
 */

module Response = MSW__GraphQL__Response

type resolverOptions<'variables> = {
  request: Fetch.Request.t,
  cookies: Js.Dict.t<string>,
  operationName: string,
  variables: 'variables,
  query: string, // unknown?
}

// TODO: allow Document aka "templateTagReturnType" in query / mutation args

/**
 * https://mswjs.io/docs/api/graphql/query
 */
@module("msw")
@scope("graphql")
external query: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
) => MSW__Common.requestHandler = "query"

/**
 * https://mswjs.io/docs/api/graphql/query
 */
@module("msw")
@scope("graphql")
external queryWithOptions: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "query"

/**
 * https://mswjs.io/docs/api/graphql/mutation
 */
@module("msw")
@scope("graphql")
external mutation: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
) => MSW__Common.requestHandler = "mutation"

/**
 * https://mswjs.io/docs/api/graphql/mutation
 */
@module("msw")
@scope("graphql")
external mutationWithOptions: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "mutation"

/**
 * https://mswjs.io/docs/api/graphql/operation
 */
@module("msw")
@scope("graphql")
external operation: (
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>
) => MSW__Common.requestHandler = "operation"

/**
 * https://mswjs.io/docs/api/graphql/operation
 */
@module("msw")
@scope("graphql")
external operationWithOptions: (
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "operation"

module Link = {
  /***
   https://mswjs.io/docs/api/graphql#graphqllinkurl
  */

  type graphqlScope

  @module("msw") @scope("graphql") external make: string => graphqlScope = "link"

  /**
   * https://mswjs.io/docs/api/graphql/query
  */
  @send
  external query: (
    graphqlScope,
    @unwrap [#Name(string) | #RegExp(Js.Re.t)],
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ) => MSW__Common.requestHandler = "query"

  /**
   * https://mswjs.io/docs/api/graphql/mutation
  */
  @send
  external mutation: (
    graphqlScope,
    @unwrap [#Name(string) | #RegExp(Js.Re.t)],
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ) => MSW__Common.requestHandler = "mutation"

  /**
   * https://mswjs.io/docs/api/graphql/operation
  */
  @send
  external operation: (
    graphqlScope,
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ) => MSW__Common.requestHandler = "operation"
}
