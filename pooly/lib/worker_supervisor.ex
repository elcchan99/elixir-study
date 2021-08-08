defmodule Pooly.WorkerSupervisor do
  @doc """
  The Supervisor that controls Worker processes
  """
  use DynamicSupervisor

  ## API
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child({m, f, a} = mfa) do
    IO.inspect(mfa, label: "start_child")
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
