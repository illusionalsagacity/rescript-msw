type t = {
  mutable status: int,
  mutable statusText: string,
  mutable body: string,
  mutable headers: Fetch.Headers.t,
  mutable delay: float,
}
