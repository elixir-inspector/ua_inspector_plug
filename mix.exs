defmodule UAInspector.Plug.Mixfile do
  use Mix.Project

  @url_github "https://github.com/elixir-inspector/ua_inspector_plug"

  def project do
    [
      app: :ua_inspector_plug,
      name: "UAInspector Plug",
      version: "0.1.0-dev",
      elixir: "~> 1.5",
      aliases: aliases(),
      deps: deps(),
      description: "UAInspector Plug",
      docs: docs(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.travis": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:plug, :ua_inspector]
    ]
  end

  defp aliases do
    [
      test: [
        "ua_inspector.download.databases --force",
        "ua_inspector.download.short_code_maps --force",
        "test"
      ]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.10", only: :test},
      {:plug, "~> 1.0", optional: true},
      {:ua_inspector, "~> 0.18", optional: true}
    ]
  end

  defp docs do
    [
      main: "UAInspector.Plug",
      source_ref: "master",
      source_url: @url_github
    ]
  end

  defp package do
    %{
      files: ["CHANGELOG.md", "LICENSE", "mix.exs", "README.md", "lib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => @url_github},
      maintainers: ["Marc Neudert"]
    }
  end
end
