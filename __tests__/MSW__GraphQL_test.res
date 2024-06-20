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

  module UserQueryWithFragmentHandler = MSW__GraphQL__Response.Make(QueryB.UserQueryWithFragment)

  testPromise("should return data for response", async () => {
    MSWServerInstance.server->MSW.Server.use({
      open MSW.GraphQL

      query(
        #Name("UserQueryWithFragment"),
        async ({variables, _}) => {
          UserQueryWithFragmentHandler.graphql(
            ~data={
              userById: Some({
                __typename: "User",
                id: variables->Js.Dict.get("id")->Belt.Option.getExn,
                avatarUrl: Some("http://test.com/avatar.png"),
                fullName: "John Doe",
              }),
            },
            {
              status: 200,
              statusText: "OK",
            },
          )
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

  testPromise("should return error for a 503", async () => {
    MSWServerInstance.server->MSW.Server.use(
      MSW.GraphQL.operationWithOptions(
        async _ => {
          MSW.Http.Response.make(#Null(Js.null), {status: 503, statusText: "Service Unavailable"})
        },
        {once: true},
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

  testPromise("should return error for a networkError", async () => {
    MSWServerInstance.server->MSW.Server.use(
      MSW.GraphQL.operationWithOptions(async _ => MSW.Http.Response.error(), {once: true}),
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
