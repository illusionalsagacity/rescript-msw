@module("msw") @variadic
external response: array<MSW__Common.responseTransformer> => MSW__MockedResponse.t = "response"

@module("msw") @scope("response") @variadic
external once: array<MSW__Common.responseTransformer> => MSW__MockedResponse.t = "once"

@module("msw") @scope("response")
external networkError: string => MSW__MockedResponse.t = "networkError"
