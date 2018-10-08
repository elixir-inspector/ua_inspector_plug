# UAInspector Plug

## Package Setup

Add both `:ua_inspector_plug` and `:ua_inspector` as dependencies
to your `mix.exs` file:

```elixir
defp deps do
  [
    # ...
    {:ua_inspector, "~> 0.18"},
    {:ua_inspector_plug, "~> 0.1"}
    # ...
  ]
end
```

## Application Setup

### Configuration

Ensure `:ua_inspector` is configured properly. There are no additional
configuration steps necessary.

### Plug

To automatically parse a clients user agent and enrich the connection you need
to add the plug into your current pipeline:

```elixir
defmodule MyRouter do
  use Plug.Router

  # ...
  plug UAInspector.Plug
  # ...

  plug :match
  plug :dispatch
end
```

Depending on how you are using plugs the actual location may vary. Please
consult your frameworks documentation to find the proper place.

Once setup the connection will be automatically enriched with the results of
a lookup based on the connections `user-agent` header:

```elixir
defmodule MyRouter do
  get "/" do
    case UAInspector.Plug.get_result(conn) do
      %{device: %{type: type}} -> send_resp(200, "Device type: #{type}")
      nil -> send_resp(404, "Unknown device type or missing user agent")
    end
  end
end
```

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
