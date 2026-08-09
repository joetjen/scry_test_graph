defmodule Scry.Test.Graph.Adapter do
  @moduledoc """
  Bridges `scry_core`'s own `Scry.Core.QueryTool` config contract
  (`backends:` returning `{engine_module, conn}`; `executor:` called as
  `(query, engine, conn)`) to `Scry.Graph.Executor`'s own `(query, conn,
  params)` shape -- `scry_graph` has no separate "engine module"
  concept at all (`Scry.Graph.Executor` operates on `Scry.Graph.
  Conn.t()` directly, that package's own `CHANGELOG.md` has the full
  reasoning), so there's nothing for a real `engine` argument to be.

  `config/config.exs` registers `conn/0` as the named backend and this
  module as `executor:` -- `run/3` below just discards the placeholder
  "engine" position `Scry.Core.QueryTool` always passes and forwards to
  the real thing.
  """

  @doc """
  The `{engine, conn}` shape `Scry.Core.QueryTool.resolve_backend/1`
  expects -- `__MODULE__` is a placeholder here, never actually
  dispatched to as an engine.
  """
  @spec conn() :: {module(), Scry.Graph.Conn.t()}
  def conn, do: {__MODULE__, Scry.Test.Graph.Conn.graph()}

  @doc false
  @spec run(term(), module(), Scry.Graph.Conn.t()) ::
          {:ok, Scry.Core.Cursor.t()} | {:error, term()}
  def run(query, _placeholder_engine, conn), do: Scry.Graph.Executor.run(query, conn)
end
