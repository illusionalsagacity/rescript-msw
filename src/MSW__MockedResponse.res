type t = {
  mutable status: int,
  mutable statusText: string,
  mutable body: string,
  mutable headers: Headers.t,
  mutable delay: float,
}
