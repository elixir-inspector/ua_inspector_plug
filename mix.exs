defmodule UAInspector.Plug.MixProject do
  use Mix.Project

  @url_github "https://github.com/elixir-inspector/ua_inspector_plug"

  def project do
    [
      app: :ua_inspector_plug,
      name: "UAInspector Plug",
      version: "0.2.0-dev",
      elixir: "~> 1.7",
      deps: deps(),
      description: "UAInspector Plug",
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.0", only: :test, runtime: false},
      {:plug, "~> 1.0"},
      {:ua_inspector, "~> 2.0"}
    ]
  end

  defp docs do
    [
      main: "UAInspector.Plug",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github}
    }
  end
end
