defmodule Pooly.Server do
  use GenServer

  alias DynamicSupervisor

  defmodule State do
    defstruct sup: nil, worker_sup: nil, size: nil, mfa: nil, monitors: nil, workers: nil
  end

  # API
  def start_link(sup, pool_config) do
    GenServer.start_link(__MODULE__, [sup, pool_config], name: __MODULE__)
  end

  # def start_link(a) do
  #   IO.inspect(a)
  # end

  def checkout do
    GenServer.call(__MODULE__, :checkout)
  end

  def checkin(worker_pid) do
    GenServer.cast(__MODULE__, {:checkin, worker_pid})
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  # Server
  def init([sup, pool_config]) when is_pid(sup) do
    IO.inspect("Server init")
    IO.inspect(pool_config, label: "pool_config")
    monitors = :ets.new(:monitors, [:private])
    init(pool_config, %State{sup: sup, monitors: monitors})
  end

  def init([{:mfa, mfa} | rest], state) do
    IO.inspect(mfa, label: "Server.init mfa")
    init(rest, %State{state | mfa: mfa})
  end

  def init([{:size, size} | rest], state) do
    init(rest, %State{state | size: size})
  end

  def init([_ | rest], state) do
    init(rest, state)
  end

  def init([], state) do
    IO.inspect("Server initiated")
    send(self(), :start_worker_supervisor)
    {:ok, state}
  end

  def handle_info(:start_worker_supervisor, state = %{sup: sup, mfa: mfa, size: size}) do
    # Start the WorkerSupervisor
    IO.inspect("Server is starting WorkerSupervisor")

    spec = %{
      id: Pooly.WorkerSupervisor,
      start: {Pooly.WorkerSupervisor, :start_link, [mfa]},
      restart: :temporary
    }

    {:ok, worker_sup} = Supervisor.start_child(sup, spec)
    # Start Worker processes under the supervision of the WorkerSupervisor
    IO.inspect("Server is requesting WorkerSupervisor to spawn workers")
    IO.inspect(worker_sup, label: "worker_sup")
    workers = prepopulate(size, worker_sup, mfa)
    {:noreply, %{state | worker_sup: worker_sup, workers: workers}}
  end

  def handle_call(:checkout, {from_pid, _ref}, %{workers: workers, monitors: monitors} = state) do
    case workers do
      [worker | rest] ->
        ref = Process.monitor(from_pid)
        true = :ets.insert(monitors, {worker, ref})
        {:reply, worker, %{state | workers: rest}}

      [] ->
        {:reply, :noproc, state}
    end
  end

  def handle_cast({:checkin, worker}, %{workers: workers, monitors: monitors} = state) do
    case :ets.lookup(monitors, worker) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(monitors, worker)
        {:noreply, %{state | workers: [pid | workers]}}

      [] ->
        {:noreply, state}
    end
  end

  def handle_info(:status, _from, %{workers: workers, monitors: monitors} = state) do
    {:reply, {length(workers), :ets.info(monitors, :size)}, state}
  end

  ## Privates

  defp prepopulate(size, sup, mfa) do
    IO.inspect("Server prepopulate")
    prepopulate(size, sup, mfa, [])
  end

  defp prepopulate(size, _sup, _mfa, workers) when size < 1 do
    workers
  end

  defp prepopulate(size, sup, mfa, workers) do
    prepopulate(size - 1, sup, mfa, [new_worker(sup, mfa) | workers])
  end

  defp new_worker(sup, {m, _, _} = mfa) do
    spec = %{id: m, start: mfa, restart: :permanent}
    {:ok, worker} = DynamicSupervisor.start_child(sup, spec)
    IO.inspect(worker, label: "created")
    worker
  end
end
