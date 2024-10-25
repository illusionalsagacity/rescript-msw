open! RescriptCore
open Vitest

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

describe("MSW__GraphQL", () => {
  let client = {
    open ApolloClient
    let cache = Cache.InMemoryCache.make()
    let uri = _ => "http://localhost:8080"
    make(~cache, ~uri, ())
  }

  afterEachPromise(() => {
    client.clearStore()
  })

  module UserQueryWithFragmentHandler = MSW__GraphQL__Response.Make(QueryB.UserQueryWithFragment)

  testPromise("should return data for response", async _suite => {
    MSWServerInstance.server->MSW.Server.use({
      open MSW.GraphQL

      query(
        #Name("UserQueryWithFragment"),
        async ({variables, _}) => {
          UserQueryWithFragmentHandler.graphql(
            ~data={
              userById: Some({
                __typename: "User",
                id: variables->Js.Dict.get("id")->Option.getExn,
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
    ->Expect.toEqual(
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

  testPromise("should return data for non-ppx response", async _suite => {
    MSWServerInstance.server->MSW.Server.use({
      MSW.GraphQL.query(
        #Name("UserQueryWithFragment"),
        async ({variables, _}) => {
          MSW.GraphQL.Response.graphql(
            ~data=Dict.fromArray([
              (
                "userById",
                Dict.fromArray([
                  ("__typename", JSON.Encode.string("User")),
                  (
                    "id",
                    variables
                    ->Js.Dict.get("id")
                    ->Option.mapOr(JSON.Encode.null, JSON.Encode.string),
                  ),
                  ("avatarUrl", JSON.Encode.string("http://test.com/avatar.png")),
                  ("fullName", JSON.Encode.string("John Doe")),
                ])->JSON.Encode.object,
              ),
            ])->JSON.Encode.object,
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
    ->Expect.toEqual(
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

  testPromise("should return error for a 503", async _suite => {
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
      ->Option.getExn
      ->(v => v.ApolloClient.Types.ApolloError.networkError)
      ->Option.getExn

    switch networkError {
    | ApolloClient.Types.ApolloError.FetchFailure(_) => expect(true)->Expect.toBeTruthy
    | BadBody(_)
    | BadStatus(_, _)
    | ParseError(_) =>
      expect(false)->Expect.toBeTruthy
    }
  })

  testPromise("should return error for a networkError", async _suite => {
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
      ->Option.getExn
      ->(v => v.ApolloClient.Types.ApolloError.networkError)
      ->Option.getExn

    switch networkError {
    | ApolloClient.Types.ApolloError.FetchFailure(_) => expect(true)->Expect.toBeTruthy
    | BadBody(_)
    | BadStatus(_, _)
    | ParseError(_) =>
      expect(false)->Expect.toBeTruthy
    }
  })
})
