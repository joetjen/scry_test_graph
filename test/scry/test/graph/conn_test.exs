defmodule Scry.Test.Graph.ConnTest do
  @moduledoc """
  `Scry.Test.Graph.Conn.graph/0` -- confirms it returns a real, working
  `Scry.Graph.Conn.t()` (prefilled with `Scry.Test.Graph.Seed`'s own
  dataset), actually executing a real traversal correctly through
  `Scry.Graph.Executor.run/3`, cycle included.
  """

  use ExUnit.Case, async: true

  alias Scry.Core.Cursor
  alias Scry.Graph.Executor
  alias Scry.Test.Graph.Conn

  defp run!(source) do
    {:ok, query} = Scry.Graph.parse(source)
    {:ok, cursor} = Executor.run(query, Conn.graph())
    Cursor.to_list(cursor)
  end

  test "an ordinary top-level query works with no VIA at all" do
    names = "SELECT Person { name }" |> run!() |> Enum.map(& &1["name"]) |> Enum.sort()
    assert names == ["Alice", "Bob", "Carol", "Dave", "Erin"]
  end

  test "VIA reaches Alice's own direct \"knows\" neighbors" do
    [alice_row] = run!(~s(SELECT Person WHERE name = "Alice" { via knows { name } }))
    names = alice_row["via"] |> Enum.map(& &1["name"]) |> Enum.sort()
    assert names == ["Bob", "Dave"]
  end

  test "the seed's own cycle (Erin knows Alice) is real -- HOPS 1-10 terminates, doesn't loop forever" do
    [alice_row] =
      run!(~s(SELECT Person WHERE name = "Alice" { via knows HOPS 1-10 { name } }))

    names = alice_row["via"] |> Enum.map(& &1["name"])
    refute "Alice" in names
    assert "Erin" in names
  end

  test "calling graph/0 twice returns independent, identically-seeded connections" do
    conn1 = Conn.graph()
    conn2 = Conn.graph()
    assert conn1 == conn2
  end
end
