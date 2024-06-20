/**
https://mswjs.io/docs/api/delay#explicit-delay
*/
@module("msw")
external delay: int => promise<unit> = "delay"

/**
https://mswjs.io/docs/api/delay#delay-modes
*/
@module("msw")
external realistic: (@as("real") _, unit) => promise<unit> = "delay"

/**
https://mswjs.io/docs/api/delay#delay-modes
*/
@module("msw")
external infinite: (@as("infinite") _, unit) => promise<unit> = "delay"
