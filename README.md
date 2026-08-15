# scry_test_graph

Shared test fixtures for
[`scry_graph`](https://github.com/joetjen/scry_graph): one seed
dataset (`Scry.Test.Graph.Seed`) — a small social graph, five `Person`
nodes and a `"knows"` edge set that includes a genuine cycle — servable
through `Scry.Test.Graph.Conn.graph/0`.

**Only one constructor, not a family of interchangeable backends.**
Unlike [`scry_test_core`](https://github.com/joetjen/scry_test_core)/
[`scry_test_time_series`](https://github.com/joetjen/scry_test_time_series)
(one constructor *per* interchangeable `Scry.Core.EngineBehaviour`
backend, for genuine cross-backend parity testing), `scry_graph` has
exactly one executor (`Scry.Graph.Executor`, operating on `Scry.Graph.
Conn.t()` directly — that package's own `CHANGELOG.md` has the full
"no existing `EngineBehaviour` callback receives the whole graph `VIA`
needs" reasoning). There's nothing to parity-test *against* yet. This
package's own value is narrower and still real: a shared, realistic
fixture (reusable by an application's own integration tests, or this
kind's own future real adapter's test suite, once one exists) plus
`scry_core`'s own `mix scry.query`/`mix scry.iex`, configured here, for
ad-hoc exploration.

Source: <https://github.com/joetjen/scry_test_graph>. The kind this
exercises lives in
[`scry_graph`](https://github.com/joetjen/scry_graph).

## Usage

```elixir
{:ok, query} =
  Scry.Graph.parse(~s(SELECT Person WHERE name = "Alice" { via knows { name } }))

{:ok, cursor} = Scry.Graph.Executor.run(query, Scry.Test.Graph.Conn.graph())
Scry.Core.Cursor.to_list(cursor)
# [%{"via" => [%{"name" => "Bob"}, %{"name" => "Dave"}]}]
```

## `mix scry.query`/`mix scry.iex`

Both tasks live in `scry_core` itself (a generic, config-driven pair —
see that package's own README/`Scry.Core.QueryTool` moduledoc). This
package's own `config/config.exs` wires them to `Scry.Graph.parse/1`
and `Scry.Test.Graph.Conn.graph/0` via a small `Scry.Test.Graph.
Adapter` (bridging `Scry.Graph.Executor`'s own `(query, conn, params)`
shape to the `(query, engine, conn)` one `Scry.Core.QueryTool` expects
— `scry_graph` has no separate "engine" concept at all, so there's
nothing real for that middle argument to be):

```console
$ mix scry.query 'SELECT Person WHERE name = "Alice" { via knows { name } }'
$ mix scry.iex
```

No `--backend` flag needed — this package registers exactly one named
backend, used implicitly.

## Installation

```elixir
def deps do
  [
    {:scry_test_graph, "~> 0.1.0", only: :test}
  ]
end
```

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc):

- Released versions are published to [HexDocs](https://hexdocs.pm) once the
  package ships, at <https://hexdocs.pm/scry_test_graph>.
- Latest `main` is built and deployed automatically by
  [`.github/workflows/docs.yml`](.github/workflows/docs.yml) to
  [GitHub Pages](https://joetjen.github.io/scry_test_graph/) on every push to `main`.
