use Mix.Config

config :auth_plug,
  api_key: System.get_env("AUTH_API_KEY")
