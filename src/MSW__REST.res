module Raw = MSW__REST__Raw
module Request = MSW__REST__Request
module Response = MSW__Raw__Response

type responseBuilder = MSW__Common.responseBuilder

type response = {
  res: unit => responseBuilder,
  once: unit => responseBuilder,
  networkError: string => responseBuilder,
}

type handler<'requestBody, 'responseBody> = (
  MSW__REST__Request.t<'requestBody>,
  response,
  MSW__Context.WrappedREST.t<'responseBody>,
) => responseBuilder

type callFunc = Response | Once | NetworkError(string)

let handle = (handler, . req, _res, ctx) => {
  let func = ref(Response)
  let wrappedContext = MSW__Context.WrappedREST.wrap(ctx)
  let wrappedRes = {
    res: () => {
      func := Response
      []
    },
    once: () => {
      func := Once
      []
    },
    networkError: message => {
      func := NetworkError(message)
      []
    },
  }
  let transformers = handler(req, wrappedRes, wrappedContext)
  switch func.contents {
  | Response => MSW__ResponseResolver.response(transformers)
  | Once => MSW__ResponseResolver.once(transformers)
  | NetworkError(message) => MSW__ResponseResolver.networkError(message)
  }
}

let all = (name, fn) => Raw.all(name, handle(fn))

let get = (name, fn) => Raw.get(name, handle(fn))

let post = (name, fn) => Raw.post(name, handle(fn))

let put = (name, fn) => Raw.put(name, handle(fn))

let patch = (name, fn) => Raw.patch(name, handle(fn))

let delete = (name, fn) => Raw.delete(name, handle(fn))

let options = (name, fn) => Raw.options(name, handle(fn))
