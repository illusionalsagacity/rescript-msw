type t = {
  method?: Request.method,
  headers?: Js.Dict.t<string>,
  mode?: Request.mode,
  credentials?: Request.credentials,
  cache?: Request.cache,
  redirect?: Request.redirect,
  referrer?: string,
  integrity?: string,
}
