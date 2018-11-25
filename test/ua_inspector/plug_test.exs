defmodule UAInspector.PlugTest do
  use ExUnit.Case
  use Plug.Test

  defmodule Router do
    use Plug.Router

    plug UAInspector.Plug

    plug :match
    plug :dispatch

    get "/" do
      case UAInspector.Plug.get_result(conn) do
        %{user_agent: nil} -> send_resp(conn, 404, "Missing user agent")
        %{user_agent: ""} -> send_resp(conn, 404, "Empty user agent")
        %{device: :unknown} -> send_resp(conn, 404, "Unknown device type")
        %{device: %{type: type}} -> send_resp(conn, 200, "Device type: " <> type)
      end
    end
  end

  @opts Router.init([])

  test "empty result for missing agent" do
    conn = conn(:get, "/") |> Router.call(@opts)

    assert 404 == conn.status
    assert %UAInspector.Result{user_agent: nil} == UAInspector.Plug.get_result(conn)
  end

  test "empty result for empty agent" do
    conn =
      conn(:get, "/")
      |> put_req_header("user-agent", "")
      |> Router.call(@opts)

    assert 404 == conn.status
    assert %UAInspector.Result{user_agent: ""} == UAInspector.Plug.get_result(conn)
  end

  test "empty result for unknown agent" do
    agent = "some.unknown.device"

    conn =
      conn(:get, "/")
      |> put_req_header("user-agent", agent)
      |> Router.call(@opts)

    assert 404 == conn.status

    assert %UAInspector.Result{
             device: :unknown,
             user_agent: agent
           } = UAInspector.Plug.get_result(conn)
  end

  test "result for agent" do
    agent =
      "Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53"

    conn =
      conn(:get, "/")
      |> put_req_header("user-agent", agent)
      |> Router.call(@opts)

    assert 200 == conn.status

    assert %UAInspector.Result{
             client: %UAInspector.Result.Client{},
             device: %UAInspector.Result.Device{},
             os: %UAInspector.Result.OS{},
             user_agent: agent
           } = UAInspector.Plug.get_result(conn)
  end
end
