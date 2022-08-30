# ReScript MSW

This package is intended to be an ergonomic, data-first, wrapper for ReScript bindings to [msw](https://mswjs.io/), particularly for usage with [graphql-ppx](https://graphql-ppx.com/). It can also be used for REST APIs, especially in combination with JSON codecs like:

- [rescript-json-combinators](https://github.com/glennsl/rescript-json-combinators)
- [bs-json](https://github.com/glennsl/bs-json)
- [rescript-struct](https://github.com/DZakh/rescript-struct)

Shout out to some older bindings to MSW by jichi [here](https://github.com/jihchi/res-msw).

## Usage

### graphql-ppx

This package provides an ergonomic wrapper for use with `graphql-ppx` under `MSW.GraphQL_PPX`. It uses the modules returned by `%graphql` to serialize and deserialize operations; no more hand-writing verbose `Js.Json` chains with `Js.Dict.fromArray->Js.Json.object_`. Your request handler and responses are also typed to your operation module. This package also wraps the request handler and context for more ergonomic usage with fast pipe.

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
  GraphQL_PPX.query(module(UserQuery), #String("UserQuery"), ({variables}, {res}, ctx) => {
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
  }),
)
```

More example usage can be found in [the test](https://github.com/illusionalsagacity/rescript-msw/blob/master/__tests__/MSW__GraphQL__PPX_test.res) which will also show you how to write your own tests using `rescript-apollo-client`.

### GraphQL

If you are not using `graphql-ppx`, the standard MSW GraphQL handlers are available as zero-cost ReScript bindings under `MSW.GraphQL`


### REST

Zero-cost bindings are available for the REST handlers. Since there is no standard module type for ReScript JSON serialization libraries, these bindings will require you to encode and decode the responses yourself.
