# Metex

This is the exercise from the book, The little Elixir & OTP Guidebook.
To build a weather application in Chapter 3.2.

## Installation

```elixir
mix deps.get
```

## Get Started

### Get API key from openweather

The application requires access to openweathermap.
Please sign up and got to https://home.openweathermap.org/api_keys get your access key. Then, set it to your shell or put it in a `.env` file.

### Query weather

```elixir
# Source your API key
source .env

# Start an iex shell
iex -S mix

# Query weather
Metex.Worker.temperature_of "Hong Kong"
```

You should expect something returns like:
`"Hong Kong: 31.0°C"`
