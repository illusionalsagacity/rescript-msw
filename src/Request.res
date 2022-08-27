type method = [
  | #CONNECT
  | #DELETE
  | #GET
  | #HEAD
  | #OPTIONS
  | #PATCH
  | #POST
  | #PUT
  | #TRACE
]

type cache = [
  | #default
  | #"no-store"
  | #reload
  | #"no-cache"
  | #"force-cache"
  | #"only-if-cached"
]

type mode = [
  | #"same-origin"
  | #"no-cors"
  | #cors
  | #navigate
  | #websocket
]

type credentials = [#"include" | #omit | #"same-origin"]

type redirect = [#follow | #error | #manual]

type referrerPolicy = [
  | #""
  | #"no-referrer"
  | #"no-referrer-when-downgrade"
  | #origin
  | #"origin-when-cross-origin"
  | #"same-origin"
  | #"strict-origin"
  | #"strict-origin-when-cross-origin"
  | #"unsafe-url"
]
