type t<'body, 'variables> = {
  url: Url.t,
  method: Request.method,
  headers: Headers.t,
  cookies: Js.Dict.t<string>,
  params: Js.Dict.t<string>,
  bodyUsed: bool,
  cache: Request.cache,
  mode: Request.mode,
  credentials: Request.credentials,
  redirect: Request.redirect,
  referrer: string,
  referrerPolicy: Request.referrerPolicy,
  integrity: string,
  destination: string,
  keepalive: bool,
  variables: 'variables,
}

@send
external json: t<'body, 'variables> => Js.Promise.t<'body> = "json"

@send
external passthrough: t<'body, 'variables> => MSW__Raw__Response.t = "passthrough"
