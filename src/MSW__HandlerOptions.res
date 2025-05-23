/***
Defines options for request handlers in MSW.
*/

/**
 If `once` is set to `true`, the request handler will be removed after its first invocation.
 This is useful for mocking a response that should only occur once, like an initial data load or a specific one-time action.

 https://mswjs.io/docs/api/request-handler#request-handler-options

 Example:
 ```rescript
 MSW.Http.get("/resource", _ => MSW.HttpResponse.text("Temporary content", {status: 200}), ~options={once: true})
 ```
 After the first GET request to "/resource", this handler will be removed.
 Subsequent requests will not be intercepted by this handler unless it's added again.
 */
type t = {once?: bool}
