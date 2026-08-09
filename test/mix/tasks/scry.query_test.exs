defmodule Mix.Tasks.Scry.QueryConfigTest do
  @moduledoc """
  `mix scry.query`/`mix scry.iex` themselves live in `scry_core` (a
  generic, config-driven pair -- see that package's own `Scry.Core.
  QueryTool` moduledoc) and are already fully tested there. This is
  just a smoke test that THIS package's own `config/config.exs` wires
  them correctly end to end -- `Scry.Graph.parse/1` as the parser,
  `Scry.Test.Graph.Adapter` bridging `Scry.Graph.Executor`'s own
  `(query, conn, params)` shape to the `(query, engine, conn)` one
  `Scry.Core.QueryTool` expects, and `Scry.Test.Graph.Conn.graph/0` as
  the sole named backend.
  """

  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  test "a VIA query runs correctly through the configured backend" do
    output =
      capture_io(fn ->
        Mix.Tasks.Scry.Query.run([~s(SELECT Person WHERE name = "Alice" { via knows { name } })])
      end)

    assert output =~ ~s("name" => "Bob")
    assert output =~ ~s("name" => "Dave")
  end

  test "the sole configured backend is used implicitly, with no --backend flag needed" do
    output = capture_io(fn -> Mix.Tasks.Scry.Query.run(["SELECT Person { name }"]) end)
    assert output =~ ~s("name" => "Alice")
  end
end
