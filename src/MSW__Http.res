/***
 * https://mswjs.io/docs/api/http
 */
module Response = MSW__HttpResponse

type resolverOptions = {
  request: Fetch.Request.t,
  params: Js.Dict.t<string>,
  cookies: Js.Dict.t<string>,
}

@module("msw") @scope("http")
external all: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "all"

@deprecated @module("msw") @scope("http")
external allWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "all"

@module("msw") @scope("http")
external head: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "head"

@deprecated @module("msw") @scope("http")
external headWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "head"

@module("msw") @scope("http")
external get: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "get"

@deprecated @module("msw") @scope("http")
external getWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "get"

@module("msw") @scope("http")
external post: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "post"

@deprecated("Use post instead") @module("msw") @scope("http")
external postWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "post"

@module("msw") @scope("http")
external put: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "put"

@deprecated("Use put instead") @module("msw") @scope("http")
external putWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "put"

@module("msw") @scope("http")
external patch: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "patch"

@deprecated("Use patch instead") @module("msw") @scope("http")
external patchWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "patch"

@module("msw") @scope("http")
external delete: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "delete"

@deprecated("Use delete instead") @module("msw") @scope("http")
external deleteWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "delete"

@module("msw") @scope("http")
external options: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  ~options: MSW__HandlerOptions.t=?,
) => MSW__Common.requestHandler = "options"

@deprecated("Use options instead") @module("msw") @scope("http")
external optionsWithOptions: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  resolverOptions => promise<MSW__HttpResponse.t>,
  MSW__HandlerOptions.t,
) => MSW__Common.requestHandler = "options"
