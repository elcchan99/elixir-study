# Pooly

Chapter 6, Pooly worker pool

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pooly` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pooly, "~> 0.1.0"}
  ]
end
```

## Plan ahead

```elixir

pool_config = [
  mfs: {SampleWorker, :start_link, []},
  size: 5,
]

```

## 6.3

```elixir

{:ok, worker_sup} = Pooly.WorkerSupervisor.start_link({SampleWorker, :start_link, []})

{:ok, child_pid} = DynamicSupervisor.start_child(worker_sup, %{id: SampleWorker, start: {SampleWorker, :start_link, []}})

DynamicSupervisor.which_children(worker_sup)

DynamicSupervisor.count_children(worker_sup)

SampleWorker.stop(child_pid)

DynamicSupervisor.which_children(worker_sup)
```
