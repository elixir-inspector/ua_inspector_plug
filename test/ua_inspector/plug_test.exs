defmodule UAInspector.PlugTest do
  use ExUnit.Case
  use Plug.Test

  defmodule Router do
    use Plug.Router

    plug UAInspector.Plug

    plug :match
    plug :dispatch

    get "/", do: send_resp(conn, 200, "OK")
  end

  @opts Router.init([])

  test "returns 200" do
    assert 200 == conn(:get, "/") |> Router.call(@opts) |> Map.fetch!(:status)
  end
end
