/***
Provides bindings for MSW's GraphQL response handlers, allowing you to create mock GraphQL responses.

https://mswjs.io/docs/api/graphql
*/

module Response = MSW__GraphQL__Response

/**
Options passed to a GraphQL resolver function.

'variables The type of the GraphQL variables.
*/
type resolverOptions<'variables> = {
  request: Fetch.Request.t,
  cookies: Js.Dict.t<string>,
  operationName: string,
  variables: 'variables,
  query: string, // unknown?
}

// TODO: allow Document aka "templateTagReturnType" in query / mutation args

/**
Creates a GraphQL query handler.
The handler will match requests based on the operation name (string or regex).

https://mswjs.io/docs/api/graphql/query

Example:
```rescript
MSW.GraphQL.query(#Name("GetUser"), ({variables}) => {
  MSW.GraphQL.Response.graphql(
    ~data={"user": {"id": variables["id"], "name": "John Doe"}}->Obj.magic,
    {status: 200},
  )->Promise.resolve
})
```
*/
@module("msw")
@scope("graphql")
external query: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "query"

/**
Creates a GraphQL query handler with explicit options.

https://mswjs.io/docs/api/graphql/query
*/
@module("msw")
@scope("graphql")
@deprecated("Use query with the optional `~options` parameter instead.")
external queryWithOptions: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "query"

/**
Creates a GraphQL mutation handler.
The handler will match requests based on the operation name (string or regex).

https://mswjs.io/docs/api/graphql/mutation

Example:
```rescript
MSW.GraphQL.mutation(#Name("CreateUser"), async ({variables}) => {
  MSW.GraphQL.Response.graphql(
    ~data={"createUser": {"id": "new-id", "name": variables["name"]}}->Obj.magic,
    {status: 201},
  )
})
```
*/
@module("msw")
@scope("graphql")
external mutation: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "mutation"

/**
Creates a GraphQL mutation handler with explicit options.

https://mswjs.io/docs/api/graphql/mutation
*/
@module("msw")
@scope("graphql")
@deprecated("Use mutation instead")
external mutationWithOptions: (
  @unwrap [#Name(string) | #RegExp(Js.Re.t)],
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "mutation"

/**
Creates a GraphQL handler that intercepts any GraphQL operation (query or mutation).

https://mswjs.io/docs/api/graphql/operation
*/
@module("msw")
@scope("graphql")
external operation: (
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "operation"

/**
Creates a GraphQL handler that intercepts any GraphQL operation, with explicit options.

https://mswjs.io/docs/api/graphql/operation
*/
@module("msw")
@scope("graphql")
@deprecated("Use operation instead")
external operationWithOptions: (
  resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "operation"

/***
https://mswjs.io/docs/api/graphql#graphqllinkurl
*/
module Link = {
  type graphqlScope

  @module("msw") @scope("graphql") external make: string => graphqlScope = "link"

  /**
  https://mswjs.io/docs/api/graphql/query
  */
  @send
  external query: (
    graphqlScope,
    @unwrap [#Name(string) | #RegExp(Js.Re.t)],
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
    ~options: MSW__HandlerOptions.t=?,
  ) => MSW__Common.requestHandler = "query"

  /**
  https://mswjs.io/docs/api/graphql/mutation
  */
  @send
  external mutation: (
    graphqlScope,
    @unwrap [#Name(string) | #RegExp(Js.Re.t)],
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
    ~options: MSW__HandlerOptions.t=?,
  ) => MSW__Common.requestHandler = "mutation"

  /**
  https://mswjs.io/docs/api/graphql/operation
  */
  @send
  external operation: (
    graphqlScope,
    resolverOptions<'variables> => promise<MSW__HttpResponse.t>,
    ~options: MSW__HandlerOptions.t=?,
  ) => MSW__Common.requestHandler = "operation"
}
