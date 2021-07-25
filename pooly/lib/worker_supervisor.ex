defmodule Pooly.WorkerSupervisor do
  use DynamicSupervisor

  ## API
  def start_link({_, _, _} = init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg)
  end

  def start_child({m, f, a}) do
    spec = %{id: m, start: {m, f, a}, restart: :permanent}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  ## Callbacks
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      max_restarts: 5,
      max_seconds: 5,
      extra_arguments: [init_arg]
    )
  end
end
