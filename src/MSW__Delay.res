/***
Provides bindings for MSW's `delay` utility, allowing you to simulate network latency in your mock responses.
https://mswjs.io/docs/api/delay
*/

/**
Delays the response by a specified number of milliseconds.

https://mswjs.io/docs/api/delay#explicit-delay

Usage:
```rescript
let getUserHandler = MSW.Http.get("/user", async _ => {
  await MSW.Delay.delay(1500)
  Js.Dict.empty()->Js.Json.object_->MSW.HttpResponse.json({status: 200})
})
```
*/
@module("msw")
external delay: int => promise<unit> = "delay"

/**
Delays the response by a random duration, simulating realistic network latency (usually between 10ms and 150ms).

https://mswjs.io/docs/api/delay#delay-modes

Usage:
```rescript
let getUserHandler MSW.Http.get("/user", async _ => {
  await MSW.Delay.realistic()
  Js.Dict.empty()->Js.Json.object_->MSW.HttpResponse.json({status: 200})
})
```
*/
@module("msw")
external realistic: (@as("real") _, unit) => promise<unit> = "delay"

/**
Delays the response indefinitely. The response will never be returned.
This is useful for testing scenarios like request timeouts or infinite loading states.

https://mswjs.io/docs/api/delay#delay-modes

Usage:
```rescript
let getUserHandler = MSW.Http.get("/user", async _ => {
  await MSW.Delay.infinite()
  // This will never be reached
  Js.Dict.empty()->Js.Json.object_->MSW.HttpResponse.json({status: 200})
})
```
*/
@module("msw")
external infinite: (@as("infinite") _, unit) => promise<unit> = "delay"
