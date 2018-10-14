defmodule UAInspector.Plug do
  @moduledoc """
  UAInspector Plug
  """

  import Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    lookup =
      case get_req_header(conn, "user-agent") do
        [] -> UAInspector.parse(nil)
        [agent | _] -> UAInspector.parse(agent)
      end

    put_private(conn, :ua_inspector, lookup)
  end

  @doc """
  Returns the lookup result from the connection.
  """
  @spec get_result(Plug.Conn.t()) :: nil | UAInspector.Result.t()
  def get_result(conn), do: conn.private[:ua_inspector]
end
