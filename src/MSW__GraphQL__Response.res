external unsafeAsJson: 'a => Js.Json.t = "%identity"

module Location = {
  type t = {
    line: int,
    column: int,
  }

  let serialize = (location: t) => {
    Js.Dict.fromArray([
      ("line", Js.Int.toFloat(location.line)->Js.Json.number),
      ("column", Js.Int.toFloat(location.column)->Js.Json.number),
    ])->Js.Json.object_
  }
}

module GraphQLError = {
  type t = {
    message: string,
    locations?: array<Location.t>,
    path?: array<string>,
    extensions?: Js.Dict.t<Js.Json.t>,
  }

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

type t<'data> = {
  data: 'data,
  errors?: array<GraphQLError.t>,
  extensions?: Js.Json.t,
}

module Make: (Operation: MSW__Common.GraphQLPPXOperation) =>
{
  type responseData = Operation.t
  type rawResponseData = Operation.Raw.t

  let graphql: (
    ~data: Operation.t,
    ~errors: array<GraphQLError.t>=?,
    ~extensions: Js_dict.t<Js.Json.t>=?,
    MSW__HttpResponse.httpResponseInit,
  ) => MSW__HttpResponse.t
} = (Operation: MSW__Common.GraphQLPPXOperation) => {
  type responseData = Operation.t
  type rawResponseData = Operation.Raw.t

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

  let graphql = (~data, ~errors=?, ~extensions=?, httpResponseInit) => {
    serialize(~data, ~errors?, ~extensions?)->MSW__HttpResponse.json(httpResponseInit)
  }
}

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
