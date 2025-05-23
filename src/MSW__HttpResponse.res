/***
Provides functions to construct HTTP responses for your MSW handlers.

https://mswjs.io/docs/api/http-response
*/

/**
An opaque type representing an HTTP response, compatible with the standard `Response` Web API.
Instances are created using functions like `HttpResponse.json()`, `HttpResponse.text()`, etc.

https://mswjs.io/docs/api/http-response
*/
type t

/**
Represents the type of the response, mirroring the `ResponseType` enum from the Fetch standard.

https://developer.mozilla.org/en-US/docs/Web/API/Response/type
*/
type responseType = [#basic | #cors | #default | #error | #opaque | #opaqueredirect]

/**
Initialization options for creating an HTTP response, similar to the `ResponseInit` dictionary from the Fetch API.

https://developer.mozilla.org/en-US/docs/Web/API/Response/Response#init
*/
type httpResponseInit = {
  status?: int,
  statusText?: string,
  headers?: Fetch.Headers.init,
  @as("type") type_?: responseType,
}

/**
Constructs a new `HttpResponse` instance.

https://mswjs.io/docs/api/http-response/#new-httpresponsebody-init

Usage:
```rescript
let response = MSW.HttpResponse.make(
  #String("Hello world"),
  {status: 200, headers: Fetch.Headers.make([("Content-Type", "text/plain")])},
)
```
*/
@new
@module("msw")
external make: (
  @unwrap
  [
    | #ArrayBuffer(Js.TypedArray2.ArrayBuffer.t)
    | #Blob(Fetch.Blob.t)
    | #FormData(Fetch.FormData.t)
    | #String(string)
    | #Null(Js.Null.t<_>)
    | #Undefined(Js.Undefined.t<_>)
  ],
  httpResponseInit,
) => t = "HttpResponse"

/**
Simulates a network error. When returned from a handler, the client will perceive it as a failed network request.

https://mswjs.io/docs/api/http-response/#httpresponseerror

Usage:
```rescript
MSW.Http.get(#URL("/user"), async _ => MSW.HttpResponse.error())
```
*/
@module("msw")
@scope("HttpResponse")
external error: unit => t = "error"

/**
Creates a `Response` instance with the `Content-Type: text/plain` header and the given string as the response body.

https://mswjs.io/docs/api/http-response/#httpresponsetextbody-init

Usage:
```rescript
MSW.HttpResponse.text("Hello world", {status: 200})
```
*/
@module("msw")
@scope("HttpResponse")
external text: (string, httpResponseInit) => t = "text"

/**
Creates a `Response` instance with the `Content-Type: text/html` header and the given string as the response body.

https://mswjs.io/docs/api/http-response/#httpresponsehtmlbody-init

Usage:
```rescript
MSW.HttpResponse.html("<h1>Hello</h1>", {status: 200})
```
*/
@module("msw")
@scope("HttpResponse")
external html: (string, httpResponseInit) => t = "html"

/**
Creates a `Response` instance with the `Content-Type: application/json` header.
The body is automatically stringified from the given `Js.Json.t` value.

https://mswjs.io/docs/api/http-response/#httpresponsejsonbody-init

Usage:
```rescript
[("id", Js.Json.string("abc"))]
  ->Js.Dict.fromArray
  ->Js.Json.object_
  ->MSW.HttpResponse.json({status: 200})
```
*/
@module("msw")
@scope("HttpResponse")
external json: (Js.Json.t, httpResponseInit) => t = "json"

/**
Creates a `Response` instance with the `Content-Type: application/json` header.
The body is automatically stringified from the given ReScript object (record or abstract object).
This is a convenience wrapper around `json` for ReScript objects.

https://mswjs.io/docs/api/http-response/#httpresponsejsonbody-init

Usage:
```rescript
MSW.HttpResponse.jsonObj({"id": "abc", "value": 123}, {status: 200})
```
*/
@module("msw")
@scope("HttpResponse")
external jsonObj: ({..} as 'json, httpResponseInit) => t = "json"

/*
Creates a `Response` instance with the `Content-Type: text/xml` header and the given string as the response body.
https://mswjs.io/docs/api/http-response/#httpresponsexmlbody-init

Usage:
```rescript
MSW.HttpResponse.xml("<user><id>abc</id></user>", {status: 200})
```
 */
@module("msw") @scope("HttpResponse")
external xml: (string, httpResponseInit) => t = "xml"

/**
Creates a `Response` instance with the given `ArrayBuffer` as the response body.
Sets the `Content-Type` header appropriately if not specified.

https://mswjs.io/docs/api/http-response/#httpresponsearraybufferbody-init
*/
@module("msw")
@scope("HttpResponse")
external arrayBuffer: (Js.TypedArray2.ArrayBuffer.t, httpResponseInit) => t = "arrayBuffer"

/**
Creates a `Response` instance with the given `FormData` as the response body.
Sets the `Content-Type: multipart/form-data` header appropriately if not specified.

https://mswjs.io/docs/api/http-response/#httpresponseformdatabody-init

Usage:
```rescript
let formData = Fetch.FormData.make()
Fetch.FormData.append(formData, "key", "value")
MSW.HttpResponse.formData(formData, {status: 200})
```
*/
@module("msw")
@scope("HttpResponse")
external formData: (Fetch.FormData.t, httpResponseInit) => t = "formData"
