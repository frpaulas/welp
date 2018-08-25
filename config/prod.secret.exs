use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :wlp, WlpWeb.Endpoint,
  secret_key_base: "y8KmhCFH0aDu19CDmsFpSo6qtrz5rxeLDByOGCUKkflgKO3P0gZuHiAu1VGiuEvU"

# Configure your database
config :wlp, Wlp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wlp_prod",
  pool_size: 15
