# Ring

From book Benjamin Tan Wei Hao - The little Elixir & OTP Guidebook.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ring` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ring, "~> 0.1.0"}
  ]
end
```

## 5.1.3

```elixir
pids = Ring.create_processes(5)

Ring.link_processes(pids)

pids |> Enum.map(fn pid ->
  "#{inspect pid}: #{inspect Process.info(pid, :links)}"
end)

pids |> Enum.shuffle() |> Enum.first() |> send(:crash)

pids |> Enum.map(fn pid -> Process.alive?(pid) end)
```

## 5.1.4

```elixir
self

Process.flag(:trap_exit, true)

pid = spawn(fn -> receive do :crash -> 1/0 end end)

Process.link(pid)

send(pid, :crash)

self

flush
```

## 5.1.5

```elixir
pid = spawn(fn -> IO.puts("good bye." end)

Process.alive?(pid)

Process.link(pid)
```

## 5.1.8

```elixir

[p1, p2, p3] = Ring.create_processes(3)

pids = v

send(p1, :trap_exit)
send(p2, :trap_exit)

pids |> Enum.map(fn p -> Process.info(p, :trap_exit))

Process.exit(p2, :kill)

pids |> Enum.map(fn p -> Process.alive?(p) end)
```

# 5.2

```elixir
pid = spawn(fn -> receive do :crash -> 1/0 end end)

Process.monitor(pid)

send(pid, :crash)

flush

Process.monitor(pid)
```
