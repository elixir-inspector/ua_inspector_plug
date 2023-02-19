defmodule UAInspector.Plug.MixProject do
  use Mix.Project

  @url_changelog "https://hexdocs.pm/ua_inspector_plug/changelog.html"
  @url_github "https://github.com/elixir-inspector/ua_inspector_plug"
  @version "0.3.0"

  def project do
    [
      app: :ua_inspector_plug,
      name: "UAInspector Plug",
      version: @version,
      elixir: "~> 1.11",
      deps: deps(),
      description: "UAInspector Plug",
      dialyzer: dialyzer(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: :dev, runtime: false},
      {:dialyxir, "~> 1.2", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.15.0", only: :test, runtime: false},
      {:plug, "~> 1.0"},
      {:ua_inspector, "~> 3.1"}
    ]
  end

  defp dialyzer do
    [
      flags: [
        :error_handling,
        :underspecs,
        :unmatched_returns
      ],
      plt_core_path: "plts",
      plt_local_path: "plts"
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md",
        LICENSE: [title: "License"],
        "README.md": [title: "Overview"]
      ],
      formatters: ["html"],
      main: "UAInspector.Plug",
      source_ref: "v#{@version}",
      source_url: @url_github
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/helpers"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => @url_changelog,
        "GitHub" => @url_github
      }
    }
  end
end
