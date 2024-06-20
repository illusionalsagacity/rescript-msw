type t
type httpResponseInit = {
  status?: int,
  statusText?: string,
  headers?: Fetch.Headers.init,
}

// TODO:
// ReadableStream
// TypedArray
// DataView
// URLSearchParams
@new @module("msw")
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

@module("msw") @scope("HttpResponse")
external error: unit => t = "error"

@module("msw") @scope("HttpResponse")
external text: (string, httpResponseInit) => t = "json"

@module("msw") @scope("HttpResponse")
external json: ('json, httpResponseInit) => t = "json"

@module("msw") @scope("HttpResponse")
external xml: (string, httpResponseInit) => t = "xml"

@module("msw") @scope("HttpResponse")
external arrayBuffer: (Js.TypedArray2.ArrayBuffer.t, httpResponseInit) => t = "blob"

@module("msw") @scope("HttpResponse")
external formData: (Fetch.FormData.t, httpResponseInit) => t = "formData"
