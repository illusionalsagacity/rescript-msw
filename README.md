# ReScript MSW

**WARNING** This is should be considered alpha, breaking changes may happen on minor version releases in accordance with Semver.

This package is intended to be an ergonomic, data-first, wrapper for ReScript bindings to [msw](https://mswjs.io/), particularly for usage with [graphql-ppx](https://graphql-ppx.com/) and [rescript-apollo-client](https://github.com/jeddeloh/rescript-apollo-client). Being data-first bindings, it also plays nicely with [rescript-jest](https://github.com/glennsl/rescript-jest) and [rescript-promise](https://github.com/ryyppy/rescript-promise) It can also be used for REST APIs, especially in combination with JSON codecs like (in no particular order):

- [rescript-json-combinators](https://github.com/glennsl/rescript-json-combinators)
- [bs-json](https://github.com/glennsl/bs-json)
- [rescript-struct](https://github.com/DZakh/rescript-struct)
- [rescript-jzon](https://github.com/nkrkv/jzon)

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
  GraphQL_PPX.query(module(UserQuery), #Name("UserQuery"), ({variables, _}, {res, _}, ctx) => {
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
// Note that you do not need to pass the #Name parameter with operation.
server->Server.use(
  GraphQL_PPX.operation(module(UserQuery), ({variables, _}, {once, _}, ctx) => {
    once()
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

Note that you do not need to pass both the module and the name of the operation when using `GraphQL_PPX.operation`, only when using `query` or `mutation`.

More example usage can be found in [the test](https://github.com/illusionalsagacity/rescript-msw/blob/master/__tests__/MSW__GraphQL__PPX_test.res) which will also show you how to write your own tests using `rescript-apollo-client`.

### GraphQL

If you are not using `graphql-ppx`, the standard MSW GraphQL handlers are available as zero-cost ReScript bindings under `MSW.GraphQL`. Note that this won't call the parse/serialize functions for you, so the you will need to be careful to use the "inner" types if using `graphql-ppx` and choose to use this.

### REST

Zero-cost bindings are available for the REST handlers. Since there is no standard module type for ReScript JSON serialization libraries, these bindings will require you to encode and decode the responses yourself.

## Motiviation

MSW is a fantastic utility library that has completely eclipsed my usage of `@apollo/client`'s MockedProvider. In my opinion, it's a more "complete" test of your GraphQL operations, and it has been significantly less fussy in throwing spurious runtime errors or mysteriously not returning data during testing. My only complaint was that writing JSON encoders in ReScript was more effort than in TypeScript or JavaScript, and due to the way `rescript-apollo-client` + `graphql-ppx` parses GraphQL responses, writing tests in TypeScript for ReScript code while getting compiler errors is possible but tricky. Hence, these bindings.

## Acknowledgements

Shout out to some older bindings to MSW by jichi [here](https://github.com/jihchi/res-msw).
