/**
An opaque type representing a URL. This is used in MSW's HTTP handlers
to match requests by URL. It can be created from a string or a regular expression.
While the underlying JavaScript MSW library can accept `URL` objects or `RegExp` directly,
this ReScript binding often uses polymorphic variants like `#URL(string)` or `#RegExp(Js.Re.t)`
for type safety and clarity in ReScript code when passing to handler functions (e.g. `MSW.Http.get`).

This `Url.t` type itself is more of a placeholder or an internal representation if MSW were to expose
a specific object type for URLs that isn't directly a string or RegExp. In the current bindings,
you'll primarily interact with URL patterns via strings or `Js.Re.t` passed into the polymorphic variants
of handler functions like `MSW.Http.get` or `MSW.GraphQL.query`.

Refer to the documentation for specific handler functions (e.g., `MSW.Http.get`) to see how URL patterns are specified.
*/
type t
