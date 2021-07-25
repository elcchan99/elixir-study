# ThySupervisor

Writing your own Supervisor

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `thy_supervisor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:thy_supervisor, "~> 0.1.0"}
  ]
end
```

## 5.4

```elixir
{:ok, sup_pid} = ThySupervisor.start_link([])

{:ok, child_pid} = ThySupervisor.start_child(sup_pid, {ThyWorker, :start_link, []})

Process.info(sup_pid, :links)

self

Process.exit(child_pid, :crash)

Process.info(sup_pid, :links)

ThySupervisor.which_children(sup_pid)
```

### Test restart

```elixir
{:ok, sup_pid} = ThySupervisor.start_link([])

{:ok, child_pid} = ThySupervisor.start_child(sup_pid, {ThyWorker, :start_link, []})

s = ThySupervisor.which_children(sup_pid)

ThySupervisor.restart_child(sup_pid, child_pid, s[child_pid])

ThySupervisor.which_children(sup_pid)
```
