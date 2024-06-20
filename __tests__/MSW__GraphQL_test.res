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

  testPromise("should return data for response", async () => {
    MSWServerInstance.server->MSW.Server.use({
      open MSW.GraphQL

      query(
        #Name("UserQueryWithFragment"),
        (. {variables: {QueryB.UserQueryWithFragment.id: id}, _}, res, ctx) => {
          res->Response.once([
            Context.statusWithText(ctx, 200, "OK"),
            Context.data(
              ctx,
              {
                "userById": {
                  "__typename": "User",
                  "id": id,
                  "avatarUrl": "http://test.com/avatar.png",
                  "fullName": "John Doe",
                },
              },
            ),
          ])
        },
      )
    })

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
    MSWServerInstance.server->MSW.Server.use(
      MSW.GraphQL.operation(
        (. _req, res, _ctx) =>
          res->MSW__Raw__Response.once([
            _ctx->MSW__GraphQL__Context.statusWithText(503, "Not found"),
          ]),
      ),
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
