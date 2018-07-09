# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :nsg_acs,
  ecto_repos: [NsgAcs.Repo]

# Configures the endpoint
config :nsg_acs, NsgAcsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k4wTIj16Equ6vKt275bBdh1B23iJk6MSVafUn9ReZMVlFIYQd+PWWPQ/iap+G0uK",
  render_errors: [view: NsgAcsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: NsgAcs.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :nsg_acs, NsgAcs.Guard.Guardian,
  issuer: "nsgacs",
  secret_key: "HNinpKh9Ne3tr8BpjCpAEh0xzCqTIG3PWsfkR2AtzvUaRIpbs6oIQ9RcmjmGPekJ"

config :nsg_acs, NsgAcs.Guard.AuthAccessPipeline,
  module: NsgAcs.Guard.Guardian,
  error_handler: NsgAcs.Guard.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
