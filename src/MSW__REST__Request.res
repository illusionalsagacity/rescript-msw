type t<'body> = Fetch.Request.t

@send
external json: t<'body> => Js.Promise.t<Js.Json.t> = "json"

@send
external passthrough: t<'body> => MSW__Raw__Response.t = "passthrough"
