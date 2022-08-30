/***
 * This module does not use the Fetch.Request type because it has the 'body and
 * 'variables type parameters, which enforce type safety for MSW__GraphQL_PPX
 */
type t<'body, 'variables> = {
  url: Url.t,
  method: Fetch.method,
  headers: Fetch.Headers.t,
  cookies: Js.Dict.t<string>,
  params: Js.Dict.t<string>,
  bodyUsed: bool,
  cache: Fetch.requestCache,
  mode: Fetch.requestMode,
  credentials: Fetch.requestCredentials,
  redirect: Fetch.requestRedirect,
  referrer: string,
  referrerPolicy: Fetch.referrerPolicy,
  integrity: string,
  destination: string,
  keepalive: bool,
  variables: 'variables,
}

@send
external json: t<'body, 'variables> => Js.Promise.t<'body> = "json"

@send
external passthrough: t<'body, 'variables> => MSW__Raw__Response.t = "passthrough"
