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
  let server = MSW.setupServer()

  beforeAll(() => {
    MSW.Server.listenWithOptions(server, {onUnhandledRequest: #error})
  })

  afterEachPromise(() => {
    MSW.Server.resetHandlers(server)
    client.clearStore()
  })

  afterAll(() => {
    MSW.Server.close(server)
  })

  testPromise("should return data for response", () => {
    server->MSW.Server.use({
      open MSW.GraphQL

      query(
        #Name("UserQueryWithFragment"),
        (. {variables: {QueryB.UserQueryWithFragment.id: id}, _}, res, ctx) => {
          res->Response.res([
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

    client.query(~query=module(QueryB.UserQueryWithFragment), {id: "test_id"})->Promise.thenResolve(
      result => {
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
      },
    )
  })

  testPromise("should return error for networkError", () => {
    server->MSW.Server.use(
      MSW.GraphQL.operation(
        (. _req, res, _ctx) => res->MSW__Raw__Response.networkError("Not found"),
      ),
    )

    client.query(~query=module(QueryB.UserQueryWithFragment), {id: "test_id"})->Promise.then(
      result => {
        Promise.resolve(
          switch result {
          | Error({networkError: Some(_), _}) => expect(true)->toBe(true)
          | Error(_) | Ok(_) => false->expect->toBe(true)
          },
        )
      },
    )
  })
})
