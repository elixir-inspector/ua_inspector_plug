defmodule UAInspector.Plug do
  @moduledoc """
  UAInspector Plug
  """

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts), do: conn
end
