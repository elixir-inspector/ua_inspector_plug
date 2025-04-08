defmodule UAInspector.PlugTest do
  use ExUnit.Case

  import Plug.Conn
  import Plug.Test

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

  test "nil result if no lookup performed" do
    assert nil == conn(:get, "/") |> UAInspector.Plug.get_result()
  end

  test "empty result for missing agent" do
    conn = conn(:get, "/") |> Router.call(@opts)

    assert 404 == conn.status
    assert %UAInspector.Result{user_agent: ""} == UAInspector.Plug.get_result(conn)
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
             user_agent: ^agent
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
             browser_family: "Safari",
             client: %UAInspector.Result.Client{
               engine: "WebKit",
               engine_version: "537.51.1",
               name: "Mobile Safari",
               type: "browser",
               version: "7.0"
             },
             device: %UAInspector.Result.Device{
               brand: "Apple",
               model: "iPad",
               type: "tablet"
             },
             os: %UAInspector.Result.OS{name: "iOS", platform: :unknown, version: "7.0.4"},
             os_family: "iOS",
             user_agent: ^agent
           } = UAInspector.Plug.get_result(conn)
  end

  test "result with client hints" do
    agent = "client hint only"

    conn =
      conn(:get, "/")
      |> put_req_header("user-agent", agent)
      |> put_req_header("sec-ch-ua", "\"Chromium\";v=\"109\", \"Not_A Brand\";v=\"99\"")
      |> put_req_header("sec-ch-ua-mobile", "?0")
      |> put_req_header("sec-ch-ua-platform", "\"Linux\"")
      |> put_req_header("sec-fetch-dest", "document")
      |> put_req_header("sec-fetch-mode", "navigate")
      |> put_req_header("sec-fetch-site", "none")
      |> put_req_header("sec-fetch-user", "?1")
      |> Router.call(@opts)

    assert 200 == conn.status

    assert %UAInspector.Result{
             browser_family: "Chrome",
             client: %UAInspector.Result.Client{
               name: "Chromium",
               type: "browser",
               version: "109"
             },
             device: %UAInspector.Result.Device{type: "desktop"},
             os: %UAInspector.Result.OS{name: "GNU/Linux"},
             os_family: "GNU/Linux",
             user_agent: ^agent
           } = UAInspector.Plug.get_result(conn)
  end
end
