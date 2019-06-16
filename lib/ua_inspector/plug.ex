defmodule UAInspector.Plug do
  @moduledoc """
  UAInspector Plug

  ## Usage

  After ensuring `:ua_inspector` is configured you need to add the plug:

      defmodule MyRouter do
        use Plug.Router

        # ...
        plug UAInspector.Plug
        # ...

        plug :match
        plug :dispatch
      end

  Depending on how you are using plugs the actual location may vary.
  Please consult your frameworks documentation to find the proper place.

  Once setup the connection will be automatically enriched with the results of
  a lookup based on the connections `user-agent` header:

      defmodule MyRouter do
        get "/" do
          case UAInspector.Plug.get_result(conn) do
            nil -> send_resp(conn, 500, "No lookup done")
            %{user_agent: nil} -> send_resp(conn, 404, "Missing user agent")
            %{user_agent: ""} -> send_resp(conn, 404, "Empty user agent")
            %{device: :unknown} -> send_resp(conn, 404, "Unknown device type")
            %{device: %{type: type}} -> send_resp(conn, 200, "Device type: " <> type)
          end
        end
      end
  """

  import Plug.Conn

  @behaviour Plug

  def init(opts) do
    %{
      session_key: Keyword.get(opts, :session_key, "ua_inspector"),
      use_session: Keyword.get(opts, :use_session, false)
    }
  end

  def call(conn, %{use_session: true, session_key: session_key}) do
    case get_session(conn, session_key) do
      %UAInspector.Result{} = session_lookup ->
        put_private(conn, :ua_inspector, session_lookup)

      _ ->
        conn = call(conn, %{use_session: false})
        put_session(conn, :ua_inspector, conn.private[:ua_inspector])
    end
  end

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
