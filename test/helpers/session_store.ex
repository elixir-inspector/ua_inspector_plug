defmodule UAInspector.Plug.TestHelpers.SessionStore do
  @moduledoc false

  @behaviour Plug.Session.Store

  def init(_opts), do: nil

  def get(_conn, sid, nil) do
    {sid, Process.get({:session, sid}) || %{}}
  end

  def delete(_conn, sid, nil) do
    Process.delete({:session, sid})
    :ok
  end

  def put(conn, nil, data, nil) do
    sid = Base.encode64(:crypto.strong_rand_bytes(96))
    put(conn, sid, data, nil)
  end

  def put(_conn, sid, data, nil) do
    Process.put({:session, sid}, data)
    sid
  end
end
