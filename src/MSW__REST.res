/***
 * https://mswjs.io/docs/api/rest
 */

@module("msw") @scope("rest")
external all: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "all"

@module("msw") @scope("rest")
external get: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "get"

@module("msw") @scope("rest")
external post: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "post"

@module("msw") @scope("rest")
external put: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "put"

@module("msw") @scope("rest")
external patch: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "patch"

@module("msw") @scope("rest")
external delete: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "delete"

@module("msw") @scope("rest")
external options: (
  @unwrap [#String(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "options"
