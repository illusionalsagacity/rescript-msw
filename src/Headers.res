type t

@new
external empty: unit => t = "Headers"

@new
external clone: t => t = "Headers"

@new
external fromDict: Js.Dict.t<string> => t = "Headers"

@new
external fromArray: array<(string, string)> => t = "Headers"

@send
external append: (t, ~key: string, ~value: string) => unit = "append"

@send external delete: (t, string) => unit = "delete"

@send external entries: t => Js.Array2.array_like<(string, string)> = "entries"
let entries = headers => headers->entries->Js.Array2.from

/**
 * Callback format is (value, key)
 */ @send
external forEach: (t, (string, string) => unit) => unit = "forEach"

/**
 * Callback format is (value, key, headers)
 */ @send
external forEachWithHeaders: (t, (string, string, t) => unit) => unit = "forEach"

/**
 * Callback format is (. value, key)
 */ @send
external forEachU: (t, (. string, string) => unit) => unit = "forEach"

/**
 * Callback format is (. value, key, headers)
 */ @send
external forEachWithHeadersU: (t, (. string, string, t) => unit) => unit = "forEach"

@return(nullable) @send external get: (t, string) => option<string> = "get"

@send external has: (t, string) => bool = "has"

@send external keys: t => Js.Array2.array_like<string> = "keys"
let keys = headers => headers->keys->Js.Array2.from

@send external set: (t, ~key: string, ~value: string) => unit = "set"

@send external values: t => Js.Array2.array_like<string> = "values"
let values = headers => headers->values->Js.Array2.from
