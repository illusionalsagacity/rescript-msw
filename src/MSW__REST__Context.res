open MSW__Common

type t<'body>
type xml = string

@send external body: (t<'body>, 'body) => responseTransformer = "body"

/**
 * https://mswjs.io/docs/api/context/status
 */ @send
external status: (t<'body>, int) => responseTransformer = "status"

/**
 * https://mswjs.io/docs/api/context/status
 */ @send
external statusWithText: (t<'body>, int, string) => responseTransformer = "status"

/**
 * https://mswjs.io/docs/api/context/set
 */ @send
external set: (t<'body>, string, string) => responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/set
 */ @send
external setMany: (t<'body>, Js.Dict.t<array<string>>) => responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/text
 */ @send
external text: (t<string>, string) => responseTransformer = "text"

/**
 * https://mswjs.io/docs/api/context/json
 */ @send
external json: (t<Js.Json.t>, Js.Json.t) => responseTransformer = "json"

/**
 * https://mswjs.io/docs/api/context/xml
 */ @send
external xml: (t<xml>, xml) => responseTransformer = "xml"

/**
 * https://mswjs.io/docs/api/context/delay
 */ @send
external delay: (t<'body>, int) => responseTransformer = "delay"

/**
 * https://mswjs.io/docs/api/context/fetch
 */ @send
external fetch: (t<'body>, MSW__REST__Request.t<'any>) => Js.Promise.t<'response> = "fetch"

// TODO
// @send
// external fetchWithInput: (
//   t<'body>,
//   string,
//   MSW__REST__Request.requestInit,
// ) => Js.Promise.t<'response> = "fetch"
