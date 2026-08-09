# Changelog

## [Unreleased]

### Added

- Initial project scaffold: `mix.exs` (app `:scry_test_graph`, `{:scry_core, path: "../scry_core"}`/`{:scry_graph, path: "../scry_graph"}` real, unscoped dependencies until both are published to Hex), `.credo.exs`/`.formatter.exs`/`.tool-versions`, `AGENTS.md`/`CLAUDE.md`.
- `Scry.Test.Graph.Seed`: a small, realistic social graph -- five `Person` nodes and a `"knows"` edge set including a genuine cycle (Erin knows Alice, closing the loop) -- so anything exercising `Scry.Graph.Executor`'s own cycle-avoidance logic against this fixture has a real cycle to avoid, not just an acyclic tree.
- `Scry.Test.Graph.Conn.graph/0` -- the sole constructor, prefilled with the seed above. Deliberately just one, not one per interchangeable backend the way `Scry.Test.Core.Conn`/`Scry.Test.TimeSeries.Conn` have: `scry_graph` has exactly one executor (`Scry.Graph.Executor`, operating on `Scry.Graph.Conn.t()` directly, not dispatching through `Scry.Core.EngineBehaviour`), so there's no cross-backend parity to prove -- this package's own value is a shared, realistic fixture plus CLI wiring, not a parity suite.
- `Scry.Test.Graph.Adapter`: bridges `scry_core`'s own `Scry.Core.QueryTool` config contract (`backends:` returning `{engine_module, conn}`; `executor:` called as `(query, engine, conn)`) to `Scry.Graph.Executor`'s own `(query, conn, params)` shape, since `scry_graph` has no separate "engine module" concept at all. `config/config.exs` registers `Scry.Graph` as the parser and this adapter as both the sole backend and the executor, so `scry_core`'s own `mix scry.query`/`mix scry.iex` work against this fixture with no `--backend` flag needed.
- `test/scry/test/graph/conn_test.exs`: confirms `graph/0` returns a real, working connection, a real traversal runs correctly through it, and the seed's own cycle terminates rather than looping. `test/mix/tasks/scry.query_test.exs`: a light smoke test confirming this package's own `config/config.exs` wires `scry_core`'s already-tested generic tasks correctly end to end (not a re-test of the tasks themselves).
