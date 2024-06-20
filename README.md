# ReScript MSW

ReScript Bindings for [msw v2](https://mswjs.io/). For msw versions <= 1, use version `~0.1.0` of this package.

> [!WARNING]
> Breaking changes may happen on minor version releases in accordance with Semver.

## Usage

```rescript
let server = MSW.setupServer()
MSW.Server.listen(server)
...
MSW.Server.close(server)
```

### graphql-ppx

This package provides a Functor for use with `graphql-ppx` under `MSW.GraphQL.Response.Make` to serve as a GraphQL response factory. It uses the modules returned by the `%graphql` extension point to serialize and deserialize operations; no more hand-writing verbose `Js.Json` chains with `Js.Dict.fromArray->Js.Json.object_`. Your request handler and responses are also typed to your operation module.

```rescript
module UserQuery = %graphql(`
  query UserQuery($id: ID!) {
    userById(id: $id) {
      id
      avatarUrl
      fullName
    }
  }
`)

open MSW
let UserQueryHandler = GraphQL.Response.Make(UserQuery)
let handleSuccess = GraphQL.query(
  #Name("UserQuery"),
  ({request: _, variables, _}) => {
    UserQueryHandler.graphql(
      ~data={
        userById: Some({
          __typename: "foo",
          id: variables.id,
          avatarUrl: Some("http://test.com/avatar.png"),
          fullName: "John Doe",
        }),
      },
      { status: 200 },
    )
  })

let server = setupServer()
server->Server.listenWithOptions({onUnhandledRequest: #error})
server->Server.use(handleSuccess)
```

Note that you do not need to pass both the module and the name of the operation when using `GraphQL_PPX.operation`, only when using `query` or `mutation`.

More example usage can be found in [the test](https://github.com/illusionalsagacity/rescript-msw/blob/master/__tests__/MSW__GraphQL__PPX_test.res) which will also show you how to write your own tests using `rescript-apollo-client`.

### GraphQL

If you are not using `graphql-ppx`, the standard MSW GraphQL handlers are available as zero-cost ReScript bindings under `MSW.GraphQL`.

```rescript
module UserQuery = %graphql(`
  query UserQuery($id: ID!) {
    userById(id: $id) {
      id
      avatarUrl
      fullName
    }
  }
`)

open MSW
let server = setupServer()
server->Server.listenWithOptions({onUnhandledRequest: #error})
server->Server.use(
  GraphQL.query(
    #Name("UserQueryWithFragment"),
    async ({variables, _}) => {
      GraphQL.Response.graphql(
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
)
```

### Http

Zero-cost bindings are available for the Http handlers. Since there is no standard module type for the various ReScript JSON serialization libraries out there, these bindings will require you to encode and decode the responses yourself. An example using [rescript-json-combinators](https://github.com/glennsl/rescript-json-combinators) can be found in `__tests__/MSW__Http_test.res`.

Alternative libraries: (in no particular order)

- [bs-json](https://github.com/glennsl/bs-json)
- [rescript-struct](https://github.com/DZakh/rescript-struct)
- [rescript-jzon](https://github.com/nkrkv/jzon)
- [spice-ppx](https://github.com/green-labs/ppx_spice)
- [decco](https://github.com/rescript-labs/decco)

Additionally, the `HttpResponse.jsonObj` handler will accept objects for easier use in the case a serialization library is not being used:

```rescript
open MSW
let server = setupServer()
server->Server.listenWithOptions({onUnhandledRequest: #error})
server->Server.use(
  Http.get(
    #URL("http://localhost/user/:id"),
    async ({request, params, cookies}) => {
      HttpResponse.jsonObj(
        {
          "id": "1",
          "avatarUrl": "http://test.com/avatar.png",
          "fullName": "John Doe"
        },
        {
          status: 200,
          statusText: "OK",
        },
      )
    },
  )
)
```

## Motiviation

MSW is a fantastic utility library that has completely eclipsed my usage of `@apollo/client`'s `MockedProvider`. In my opinion, it's a more "complete" test of your GraphQL operations, and it has been significantly less fussy in throwing spurious runtime errors or mysteriously not returning data during testing. My only complaint was that writing JSON encoders in ReScript was more effort than in TypeScript or JavaScript, and due to the way `rescript-apollo-client` + `graphql-ppx` parses GraphQL responses, writing tests in TypeScript for ReScript code while getting compiler errors is possible but tricky. Hence, these bindings.

## Acknowledgements

Shout out to some older bindings to MSW by jichi [here](https://github.com/jihchi/res-msw).
