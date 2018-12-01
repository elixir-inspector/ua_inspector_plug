use Mix.Config

if Mix.env() == :test do
  config :ua_inspector,
    database_path: Path.join(__DIR__, "../test/database")
end
