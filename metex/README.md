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

### Start background worker process

```elixir
iex -S mix

# Spawn background process
pid = spawn(Metex.Worker, :loop, [])

# Query Singapore and flush message
send(pid, {self, "Singapore"})
flush

# 3.4
# Query multiple and flush messages
cities = ["Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]
cities |> Enum.each(fn city ->
    pid = spawn(Metex.Worker, :loop, [])
    send(pid, {self, city})
    end)
flush

# 3.5
# Query multiple by a coordinator process
cities = ["Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]
Metex.temperatures_of(cities)
```
