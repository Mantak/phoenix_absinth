# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nearby_book,
  ecto_repos: [NearbyBook.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :nearby_book, NearbyBookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "L+JOQ5NU6VKhqeT4x3HDWddHRQ0TvpOLNcwGujh4FMCm7KnAT+1J/LjHmOoN5QUJ",
  render_errors: [view: NearbyBookWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: NearbyBook.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
