type t<'data, 'extensions>

/**
 * https://mswjs.io/docs/api/context/status
 */ @send
external status: (t<'data, 'extensions>, int) => MSW__Common.responseTransformer = "status"

/**
 * https://mswjs.io/docs/api/context/status
 */ @send
external statusWithText: (t<'data, 'extensions>, int, string) => MSW__Common.responseTransformer =
  "status"

/**
 * https://mswjs.io/docs/api/context/set
 */ @send
external set: (t<'data, 'extensions>, string, string) => MSW__Common.responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/set
 */ @send
external setMany: (
  t<'data, 'extensions>,
  Js.Dict.t<array<string>>,
) => MSW__Common.responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/data
 */ @send
external data: (t<'data, 'extensions>, 'data) => MSW__Common.responseTransformer = "data"

/**
 * https://mswjs.io/docs/api/context/extensions
 */ @send
external extensions: (
  t<'data, 'extensions>,
  {..} as 'extensions,
) => MSW__Common.responseTransformer = "extensions"

/**
 * https://mswjs.io/docs/api/context/errors
 */ @send
external errors: (
  t<'data, 'extensions>,
  array<ApolloClient.Types.GraphqlError.t>,
) => MSW__Common.responseTransformer = "errors"

/**
 * https://mswjs.io/docs/api/context/delay
 */ @send
external delay: (t<'data, 'extensions>, int) => MSW__Common.responseTransformer = "delay"

// TODO
// /**
//  * https://mswjs.io/docs/api/context/fetch
//  */
// @send
// external fetch: (t<'data, 'extensions>, MSW__GraphQL__Request.t) => MSW__Common.responseTransformer = "fetch"

// TODO
// @send
// external fetchWithInput: (
//   t<'data, 'extensions>,
//   string,
//   MSW__REST__Request.requestInit,
// ) => Js.Promise.t<'response> = "fetch"
