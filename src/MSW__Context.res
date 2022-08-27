open MSW__Common

type graphQLExtensions<'a> = {..} as 'a

module WrappedGraphQL = {
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

type t_rest<'body> = {
  status: (~text: string=?, responseBuilder, int) => responseBuilder,
  set: (~header: string, ~value: string, responseBuilder) => responseBuilder,
  text: (responseBuilder, string) => responseBuilder,
  json: (responseBuilder, Js.Json.t) => responseBuilder,
  xml: (responseBuilder, string) => responseBuilder,
  delay: (responseBuilder, int) => responseBuilder,
}
