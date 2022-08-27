open Request

type t<'body> = {
  url: Url.t,
  method: method,
  headers: Headers.t,
  cookies: Js.Dict.t<string>,
  params: Js.Dict.t<string>,
  bodyUsed: bool,
  cache: cache,
  mode: mode,
  credentials: credentials,
  redirect: redirect,
  referrer: string,
  referrerPolicy: referrerPolicy,
  integrity: string,
  destination: string,
  keepalive: bool,
}

@send
external json: t<'body> => Js.Promise.t<'body> = "json"

@send
external passthrough: t<'body> => MSW__Raw__Response.t = "passthrough"
