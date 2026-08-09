import Config

# Wires this package's own single Scry.Test.Graph.Conn.graph/0
# fixture into scry_core's generic mix scry.query/mix scry.iex -- see
# Scry.Core.QueryTool's own moduledoc for the full config shape.
# parser: points at Scry.Graph.parse/1, since this package exercises
# the graph kind, not core's own degenerate one. executor: is Scry.
# Test.Graph.Adapter, not Scry.Graph.Executor directly -- the adapter
# bridges QueryTool's own (query, engine, conn) calling convention to
# Scry.Graph.Executor's (query, conn, params) shape (that module's own
# moduledoc has the full "why" -- scry_graph has no separate "engine"
# concept at all).
config :scry_core, :query_tool,
  parser: Scry.Graph,
  executor: {Scry.Test.Graph.Adapter, :run},
  backends: %{
    "graph" => {Scry.Test.Graph.Adapter, :conn}
  }
