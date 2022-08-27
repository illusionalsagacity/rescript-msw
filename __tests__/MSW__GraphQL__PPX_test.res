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

  let userQueryHandler = MSW.GraphQL_PPX.query(module(UserQuery), #String("UserQuery"))

  testPromise("should return data for response", () => {
    server->MSW.Server.use(
      userQueryHandler(
        ({variables}, {res}, ctx) => {
          res()
          ->ctx.status(200)
          ->ctx.data({
            userById: Some({
              __typename: "foo",
              id: variables.id,
              avatarUrl: Some("http://test.com/avatar.png"),
              fullName: "John Doe",
            }),
          })
        },
      ),
    )

    client.query(~query=module(UserQuery), {id: "test_id"})->Promise.thenResolve(
      result => {
        result
        ->Belt.Result.getExn
        ->expect
        ->toEqual({
          networkStatus: Ready,
          error: None,
          loading: false,
          data: {
            userById: Some({
              __typename: "foo",
              id: "test_id",
              avatarUrl: Some("http://test.com/avatar.png"),
              fullName: "John Doe",
            }),
          },
        })
      },
    )
  })

  testPromise("should return error for networkError", () => {
    server->MSW.Server.use(
      userQueryHandler((_req, {networkError}, _ctx) => networkError("Not found")),
    )

    client.query(~query=module(UserQuery), {id: "test_id"})->Promise.then(
      result => {
        Promise.resolve(
          switch result {
          | Error({networkError: Some(_)}) => expect(true)->toBe(true)
          | _ => false->expect->toBe(true)
          },
        )
      },
    )
  })
})
