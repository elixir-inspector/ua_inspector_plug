use Mix.Config

if Mix.env() == :test do
  config :ua_inspector,
    database_path: Path.expand("../test/database", __DIR__),
    startup_sync: true
end
