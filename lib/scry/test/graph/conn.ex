defmodule Scry.Test.Graph.Conn do
  @moduledoc """
  One constructor, `graph/0`, returning a ready `Scry.Graph.Conn.t()`
  prefilled with `Scry.Test.Graph.Seed`'s own data -- straight into
  `Scry.Graph.Executor.run/3`'s own second argument.

  Unlike `Scry.Test.Core.Conn`/`Scry.Test.TimeSeries.Conn` (one
  constructor *per* interchangeable `Scry.Core.EngineBehaviour`
  backend), there's only ever one constructor here: `scry_graph` has
  exactly one executor (`Scry.Graph.Executor`, operating on `Scry.
  Graph.Conn.t()` directly -- confirmed in that package's own
  `CHANGELOG.md`: no existing `EngineBehaviour` callback receives the
  whole graph `VIA` needs), not a family of interchangeable pushdown
  engines to parity-test against. This package's own value is a
  shared, realistic fixture -- reusable by anything depending on
  `scry_graph` (an application's own integration tests, this kind's
  own future real adapter's own test suite, once one exists) -- and
  `config/config.exs`, wiring `scry_core`'s own generic `mix
  scry.query`/`mix scry.iex` to use it for ad-hoc exploration.
  """

  alias Scry.Graph.Conn

  @doc "`Scry.Graph.Conn.new/2`, prefilled with `Scry.Test.Graph.Seed`'s own dataset."
  @spec graph() :: Conn.t()
  def graph do
    Conn.new(Scry.Test.Graph.Seed.nodes(), Scry.Test.Graph.Seed.edges())
  end
end
