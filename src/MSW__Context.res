open MSW__Common

module WrappedGraphQL = {
  type graphQLExtensions<'a> = {..} as 'a
  type t<'data, 'extensions> = {
    status: (~text: string=?, responseBuilder, int) => responseBuilder,
    set: (~header: string, ~value: string, responseBuilder) => responseBuilder,
    data: (responseBuilder, 'data) => responseBuilder,
    extensions: (responseBuilder, graphQLExtensions<'extensions>) => responseBuilder,
    errors: (responseBuilder, array<ApolloClient.Types.GraphqlError.t>) => responseBuilder,
    delay: (responseBuilder, int) => responseBuilder,
  }

  let wrap = (
    type responseData rawResponseData,
    module(Operation: MSW__Common.GraphQLOperation with
      type t = responseData
      and type Raw.t = rawResponseData
    ),
    ctx: MSW__GraphQL__Context.t<rawResponseData, 'extensions>,
  ): t<responseData, 'extensions> => {
    {
      status: (~text=?, responseBuilder, code) => {
        Js.Array2.concat(
          responseBuilder,
          [
            switch text {
            | Some(text) => ctx->MSW__GraphQL__Context.statusWithText(code, text)
            | None => ctx->MSW__GraphQL__Context.status(code)
            },
          ],
        )
      },
      set: (~header, ~value, responseBuilder) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__GraphQL__Context.set(header, value)])
      },
      data: (responseBuilder, data) => {
        Js.Array2.concat(
          responseBuilder,
          [ctx->MSW__GraphQL__Context.data(Operation.serialize(data))],
        )
      },
      extensions: (responseBuilder, extensions) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__GraphQL__Context.extensions(extensions)])
      },
      errors: (responseBuilder, errors) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__GraphQL__Context.errors(errors)])
      },
      delay: (responseBuilder, delay) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__GraphQL__Context.delay(delay)])
      },
    }
  }
}

module WrappedREST = {
  type t<'body> = {
    status: (~text: string=?, responseBuilder, int) => responseBuilder,
    set: (~header: string, ~value: string, responseBuilder) => responseBuilder,
    json: (responseBuilder, Js.Json.t) => responseBuilder,
    delay: (responseBuilder, int) => responseBuilder,
    // can't have different body values on the response builders
    // text: (responseBuilder, string) => responseBuilder,
    // xml: (responseBuilder, string) => responseBuilder,
  }

  let wrap = (ctx: MSW__REST__Raw__Context.t<'data>): t<'data> => {
    {
      status: (~text=?, responseBuilder, code) => {
        Js.Array2.concat(
          responseBuilder,
          [
            switch text {
            | Some(text) => ctx->MSW__REST__Raw__Context.statusWithText(code, text)
            | None => ctx->MSW__REST__Raw__Context.status(code)
            },
          ],
        )
      },
      set: (~header, ~value, responseBuilder) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__REST__Raw__Context.set(header, value)])
      },
      json: (responseBuilder, json) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__REST__Raw__Context.json(json)])
      },
      // text: (responseBuilder, string) =>
      //   Js.Array2.concat(responseBuilder, [ctx->MSW__REST__Raw__Context.text(string)]),
      delay: (responseBuilder, delay) => {
        Js.Array2.concat(responseBuilder, [ctx->MSW__REST__Raw__Context.delay(delay)])
      },
      // xml: (responseBuilder, xml) => {
      //   Js.Array2.concat(responseBuilder, [ctx->MSW__REST__Raw__Context.xml(xml)])
      // },
    }
  }
}
