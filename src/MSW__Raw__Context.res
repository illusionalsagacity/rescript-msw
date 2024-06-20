/***
 * https://mswjs.io/docs/api/context
 */

open MSW__Common

type t<'data>

/**
 * https://mswjs.io/docs/api/context/body
 */
@send
external body: (t<'body>, 'body) => responseTransformer = "body"

/**
 * https://mswjs.io/docs/api/context/status
 */
@send
external status: (t<'body>, int) => responseTransformer = "status"

/**
 * https://mswjs.io/docs/api/context/status
 */
@send
external statusWithText: (t<'body>, int, string) => responseTransformer = "status"

/**
 * https://mswjs.io/docs/api/context/set
 */
@send
external set: (t<'body>, string, string) => responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/set
 */
@send
external setMany: (t<'body>, Js.Dict.t<array<string>>) => responseTransformer = "set"

/**
 * https://mswjs.io/docs/api/context/text
 */
@send
external text: (t<string>, string) => responseTransformer = "text"

/**
 * https://mswjs.io/docs/api/context/json
 */
@send
external json: (t<Js.Json.t>, Js.Json.t) => responseTransformer = "json"

/**
 * https://mswjs.io/docs/api/context/xml
 */
@send
external xml: (t<'data>, 'data) => responseTransformer = "xml"

/**
 * https://mswjs.io/docs/api/context/delay
 */
@send
external delay: (t<'body>, int) => responseTransformer = "delay"
