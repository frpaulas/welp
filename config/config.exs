# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wlp,
  ecto_repos: [Wlp.Repo]

# Configures the endpoint
config :wlp, WlpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+OG4YVHpQrtS8rCDxgNavpCpbDTQQgFrdZrMZhD+cVav7P2kd6FHzFjkgrk3bJU7",
  render_errors: [view: WlpWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Wlp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"