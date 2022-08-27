/***
 * https://mswjs.io/docs/api/response
 */

/**
 * https://mswjs.io/docs/api/response#properties
 */
type t

type transformer = t => t

/**
 * https://mswjs.io/docs/api/response#mocked-response
 */ @variadic
let res: (
  t,
  array<transformer>,
) => MSW__MockedResponse.t = %raw(`function (res, transformers) { return res(...transformers); }`)

/**
 * https://mswjs.io/docs/api/response/once
 */ @send @variadic
external once: (t, array<transformer>) => MSW__MockedResponse.t = "once"

/**
 * https://mswjs.io/docs/api/response/network-error
 */ @send
external networkError: (t, string) => MSW__MockedResponse.t = "networkError"
