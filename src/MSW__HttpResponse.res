/**
 https://mswjs.io/docs/api/http-response
 */
type t

type responseType = [#basic | #cors | #default | #error | #opaque | #opaqueredirect]

type httpResponseInit = {
  status?: int,
  statusText?: string,
  headers?: Fetch.Headers.init,
  @as("type") type_?: responseType,
}

// TODO:
// ReadableStream
// TypedArray
// DataView
// URLSearchParams
/**
https://mswjs.io/docs/api/http-response/#new-httpresponsebody-init
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
Simulates an network error.

https://mswjs.io/docs/api/http-response/#httpresponseerror

Example Usage:
```rescript
MSW.Http.get(#URL("/user"), _options => MSW.HttpResponse.error())
```
*/
@module("msw")
@scope("HttpResponse")
external error: unit => t = "error"

/**
Creates a `Response` instance with the `Content-Type: text/text` header and given response body.

https://mswjs.io/docs/api/http-response/#httpresponsetextbody-init
 */
@module("msw")
@scope("HttpResponse")
external text: (string, httpResponseInit) => t = "text"

/**
 Creates a `Response` instance with the `Content-Type: text/html` header and given response body.

 https://mswjs.io/docs/api/http-response/#httpresponsehtmlbody-init
 */
@module("msw")
@scope("HttpResponse")
external html: (string, httpResponseInit) => t = "html"

/**
https://mswjs.io/docs/api/http-response/#httpresponsejsonbody-init
*/
@module("msw")
@scope("HttpResponse")
external json: (Js.Json.t, httpResponseInit) => t = "json"

/**
https://mswjs.io/docs/api/http-response/#httpresponsejsonbody-init
*/
@module("msw")
@scope("HttpResponse")
external jsonObj: ({..} as 'json, httpResponseInit) => t = "json"

/*
https://mswjs.io/docs/api/http-response/#httpresponsexmlbody-init
 */
@module("msw") @scope("HttpResponse")
external xml: (string, httpResponseInit) => t = "xml"

/**
 https://mswjs.io/docs/api/http-response/#httpresponsearraybufferbody-init
 */
@module("msw")
@scope("HttpResponse")
external arrayBuffer: (Js.TypedArray2.ArrayBuffer.t, httpResponseInit) => t = "arrayBuffer"

/**
 https://mswjs.io/docs/api/http-response/#httpresponseformdatabody-init
 */
@module("msw")
@scope("HttpResponse")
external formData: (Fetch.FormData.t, httpResponseInit) => t = "formData"
