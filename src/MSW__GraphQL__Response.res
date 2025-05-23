external unsafeAsJson: 'a => Js.Json.t = "%identity"

/** Represents a location (line and column) in a GraphQL query, typically used in error reporting. */
module Location = {
  /** The structure of a location, with line and column numbers. */
  type t = {
    line: int,
    column: int,
  }

  /** Serializes a `Location.t` into a `Js.Json.t` object. */
  let serialize = (location: t) => {
    [
      ("line", Js.Int.toFloat(location.line)->Js.Json.number),
      ("column", Js.Int.toFloat(location.column)->Js.Json.number),
    ]
    ->Js.Dict.fromArray
    ->Js.Json.object_
  }
}

/** Represents a single error in a GraphQL response. */
module GraphQLError = {
  /**
   The structure of a GraphQL error, including a message, optional locations, path, and extensions.

   https://spec.graphql.org/June2018/#sec-Errors
   */
  type t = {
    /** A human-readable description of the error. */
    message: string,
    /** A list of locations in the GraphQL document where the error occurred. */
    locations?: array<Location.t>,
    /** The path to the response field that encountered the error. */
    path?: array<string>,
    /** Additional information about the error, specific to the server implementation. */
    extensions?: Js.Dict.t<Js.Json.t>,
  }

  /** Serializes a `GraphQLError.t` into a `Js.Json.t` object. */
  let serialize = (error: t) => {
    let extensions = error.extensions->Belt.Option.map(Js.Json.object_)
    let locations = switch error.locations {
    | None => None
    | Some(locations) => Js.Array2.map(locations, Location.serialize)->Js.Json.array->Some
    }
    let path = Belt.Option.map(error.path, Js.Json.stringArray)
    let message = Js.Json.string(error.message)

    let err = Js.Dict.fromArray([("message", message)])

    switch locations {
    | Some(locations) => Js.Dict.set(err, "locations", locations)
    | None => ()
    }

    switch path {
    | Some(path) => Js.Dict.set(err, "path", path)
    | None => ()
    }

    switch extensions {
    | Some(extensions) => Js.Dict.set(err, "extensions", extensions)
    | None => ()
    }

    Js.Json.object_(err)
  }
}

/**
Represents the structure of a GraphQL response, containing optional data, errors, and extensions.

data: The `'data` type parameter represents the type of the `data` field in the response.
errors: An optional array of `GraphQLError.t` representing any errors that occurred during the operation.
extensions: An optional `Js.Json.t` object representing additional information provided by the server.
*/
type t<'data> = {
  data: 'data,
  errors?: array<GraphQLError.t>,
  extensions?: Js.Json.t,
}

/**
 A functor to create a GraphQL response helper module tailored to a specific GraphQL operation.
 This is particularly useful when working with operations defined using `@reasonml-community/graphql-ppx`.
 */
module Make: (Operation: MSW__Common.GraphQLPPXOperation) =>
{
  type responseData = Operation.t
  type rawResponseData = Operation.Raw.t

  /**
   Creates a GraphQL response for the specific operation.
   */
  let graphql: (
    ~data: Operation.t,
    ~errors: array<GraphQLError.t>=?,
    ~extensions: Js.Dict.t<Js.Json.t>=?,
    MSW__HttpResponse.httpResponseInit,
  ) => MSW__HttpResponse.t
} = (Operation: MSW__Common.GraphQLPPXOperation) => {
  type responseData = Operation.t
  type rawResponseData = Operation.Raw.t

  /**
   Serializes a GraphQL response structure into a `Js.Json.t` object.
   This is an internal helper used by the `graphql` function in this functor.
   */
  let serialize = (~data, ~errors=?, ~extensions=?) => {
    let body = Js.Dict.fromArray([("data", Operation.serialize(data)->unsafeAsJson)])

    switch errors {
    | Some(errors) =>
      Js.Dict.set(body, "errors", Js.Array2.map(errors, GraphQLError.serialize)->Js.Json.array)
    | None => ()
    }
    switch extensions {
    | Some(extensions) => Js.Dict.set(body, "extensions", Js.Json.object_(extensions))
    | None => ()
    }

    Js.Json.object_(body)
  }

  /**
Creates an `MSW.HttpResponse.t` for a GraphQL request, specific to the `Operation`.
The data is automatically serialized using `Operation.serialize`.

~data: The data for the GraphQL response, of type `responseData` (which is `Operation.t`).

~errors: Optional array of `GraphQLError.t`.

~extensions: Optional `Js.Dict.t<Js.Json.t>` for extensions.

~httpResponseInit: HTTP response options like status and headers.

Returns an `MSW.HttpResponse.t` ready to be returned from a handler.
*/
  let graphql = (~data, ~errors=?, ~extensions=?, httpResponseInit) => {
    serialize(~data, ~errors?, ~extensions?)->MSW__HttpResponse.json(httpResponseInit)
  }
}

/**
 A generic function to create an `MSW.HttpResponse.t` for a GraphQL request.
 Use this when you have `Js.Json.t` data directly, or when not using the `Make` functor.

 ~data: The data for the GraphQL response, as `Js.Json.t`.

 ~errors: Optional array of `GraphQLError.t`.

 ~extensions: Optional `Js.Dict.t<Js.Json.t>` for extensions.

 ~httpResponseInit: HTTP response options like status and headers.

 returns An `MSW.HttpResponse.t` ready to be returned from a handler.
 */
let graphql = (~data, ~errors=?, ~extensions=?, httpResponseInit) => {
  let body = Js.Dict.fromArray([("data", data)])

  switch errors {
  | Some(errors) =>
    Js.Dict.set(body, "errors", Js.Array2.map(errors, GraphQLError.serialize)->Js.Json.array)
  | None => ()
  }
  switch extensions {
  | Some(extensions) => Js.Dict.set(body, "extensions", Js.Json.object_(extensions))
  | None => ()
  }

  Js.Json.object_(body)->MSW__HttpResponse.json(httpResponseInit)
}
