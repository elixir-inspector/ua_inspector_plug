defmodule UAInspector.Plug.SessionTest do
  use ExUnit.Case

  import Plug.Conn
  import Plug.Test

  alias UAInspector.Plug.TestHelpers.SessionStore

  defmodule Router do
    use Plug.Router

    plug Plug.Session,
      store: SessionStore,
      key: "session_cookie"

    plug :fetch_session

    plug UAInspector.Plug,
      use_session: true,
      session_key: "ua_inspector_test"

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 204, "")
  end

  @opts Router.init([])

  test "result stored in session" do
    agent =
      "Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53"

    conn =
      conn(:get, "/")
      |> put_req_header("user-agent", agent)
      |> Router.call(@opts)

    assert %UAInspector.Result{
             client: %UAInspector.Result.Client{},
             device: %UAInspector.Result.Device{},
             os: %UAInspector.Result.OS{},
             user_agent: ^agent
           } = UAInspector.Plug.get_result(conn)
  end

  test "result read from session" do
    result = %UAInspector.Result{user_agent: "prepopulated"}
    session_opts = Plug.Session.init(store: SessionStore, key: "session_cookie")

    conn =
      conn(:get, "/")
      |> Plug.Session.call(session_opts)
      |> fetch_session()
      |> put_session("ua_inspector_test", result)
      |> Router.call(@opts)

    assert result == UAInspector.Plug.get_result(conn)
  end
end
