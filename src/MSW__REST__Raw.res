/***
 * https://mswjs.io/docs/api/rest
 */

module Context = MSW__REST__Raw__Context
module Response = MSW__Raw__Response

@module("msw") @scope("rest")
external all: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "all"

@module("msw") @scope("rest")
external get: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "get"

@module("msw") @scope("rest")
external post: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "post"

@module("msw") @scope("rest")
external put: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "put"

@module("msw") @scope("rest")
external patch: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "patch"

@module("msw") @scope("rest")
external delete: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "delete"

@module("msw") @scope("rest")
external options: (
  @unwrap [#URL(string) | #RegExp(Js.Re.t)],
  (
    . MSW__REST__Request.t<'requestBody>,
    MSW__Raw__Response.t,
    MSW__REST__Raw__Context.t<'responseBody>,
  ) => MSW__MockedResponse.t,
) => MSW__Common.requestHandler = "options"
