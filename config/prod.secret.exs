use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :welp, WelpWeb.Endpoint,
  secret_key_base: "y8KmhCFH0aDu19CDmsFpSo6qtrz5rxeLDByOGCUKkflgKO3P0gZuHiAu1VGiuEvU"

# Configure your database
config :welp, Welp.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "legereme.com",
  username: "frpaulas",
  password: "Barafundle1570",
  database: "welp",
  pool_size: 10
