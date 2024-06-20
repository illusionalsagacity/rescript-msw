open Jest
open Expect

module UserQuery = %graphql(`
  query UserQuery($id: ID!) {
    userById(id: $id) {
      id
      avatarUrl
      fullName
    }
  }
`)

module QueryB = %graphql(`
  fragment UserFragment on User {
    id
    avatarUrl
    fullName
  }
  query UserQueryWithFragment($id: ID!) {
    userById(id: $id) {
      ...UserFragment
    }
  }
`)

describe("rescript-msw", () => {
  let client = {
    open ApolloClient
    let cache = Cache.InMemoryCache.make()
    let uri = _ => "http://localhost:4000"
    make(~cache, ~uri, ())
  }

  afterEachPromise(() => {
    client.clearStore()
  })

  let userQueryHandler = MSW.GraphQL_PPX.operation(module(QueryB.UserQueryWithFragment))

  testPromise("should return data for response", async () => {
    MSW.Server.use(
      MSWServerInstance.server,
      userQueryHandler(
        ({variables: {id}, _}, {res, once: _, networkError: _}, ctx) => {
          res()
          ->ctx.status(200)
          ->ctx.data({
            userById: Some({
              __typename: "User",
              id,
              avatarUrl: Some("http://test.com/avatar.png"),
              fullName: "John Doe",
            }),
          })
        },
      ),
    )

    let result = await client.query(~query=module(QueryB.UserQueryWithFragment), {id: "test_id"})

    result
    ->expect
    ->toEqual(
      Ok({
        networkStatus: Ready,
        error: None,
        loading: false,
        data: {
          userById: Some({
            __typename: "User",
            id: "test_id",
            avatarUrl: Some("http://test.com/avatar.png"),
            fullName: "John Doe",
          }),
        },
      }),
    )
  })

  testPromise("should return error for networkError", async () => {
    MSW.Server.use(
      MSWServerInstance.server,
      userQueryHandler((_req, {networkError, _}, _ctx) => networkError("Not found")),
    )

    let result = switch await client.query(
      ~query=module(QueryB.UserQueryWithFragment),
      ~errorPolicy=All,
      {id: "test_id"},
    ) {
    | Ok(_) => None
    | Error(e) => Some(e)
    }

    let networkError =
      result
      ->Belt.Option.getExn
      ->(v => v.ApolloClient.Types.ApolloError.networkError)
      ->Belt.Option.getExn

    switch networkError {
    | ApolloClient.Types.ApolloError.FetchFailure(_) => pass
    | BadBody(_)
    | BadStatus(_, _)
    | ParseError(_) =>
      fail("expected FetchFailure")
    }
  })
})
