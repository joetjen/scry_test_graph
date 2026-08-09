defmodule Scry.Test.Graph.Seed do
  @moduledoc """
  A small, realistic social graph -- five `Person` nodes and a
  `"knows"` edge set that includes a genuine cycle (Erin knows Alice,
  closing the loop back to the start), so anything exercising
  `Scry.Graph.Executor`'s own cycle-avoidance logic against this
  fixture has a real cycle to avoid, not just an acyclic tree.

  ```
  Alice --knows--> Bob --knows--> Carol
    \\--knows--> Dave --knows--> Carol
  Carol --knows--> Erin --knows--> Alice   (closes the cycle)
  ```

  Every node has a string `"id"` field, `Scry.Graph.Conn`'s own
  requirement.
  """

  @doc "The `Scry.Graph.Conn.nodes()` half of the fixture."
  @spec nodes() :: Scry.Graph.Conn.nodes()
  def nodes do
    %{
      ["Person"] => [
        %{"id" => "alice", "name" => "Alice", "age" => 30},
        %{"id" => "bob", "name" => "Bob", "age" => 35},
        %{"id" => "carol", "name" => "Carol", "age" => 40},
        %{"id" => "dave", "name" => "Dave", "age" => 28},
        %{"id" => "erin", "name" => "Erin", "age" => 33}
      ]
    }
  end

  @doc "The `Scry.Graph.Conn.edges()` half of the fixture."
  @spec edges() :: Scry.Graph.Conn.edges()
  def edges do
    %{
      {"alice", "knows"} => ["bob", "dave"],
      {"bob", "knows"} => ["carol"],
      {"dave", "knows"} => ["carol"],
      {"carol", "knows"} => ["erin"],
      {"erin", "knows"} => ["alice"]
    }
  end
end
