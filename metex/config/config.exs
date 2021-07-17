use Mix.Config

openweather_apikey =
  System.get_env("OPENWEATHER_APIKEY") ||
    raise """
    environment variable OPENWEATHER_APIKEY is missing.
    Check https://home.openweathermap.org/api_keys
    """

config :metex, Metex.Worker,
  api_key: openweather_apikey,
  env: "local"
