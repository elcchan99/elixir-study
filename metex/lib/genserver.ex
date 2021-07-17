defmodule Metex.GenServer do
  use GenServer

  alias Metex.Worker

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
    end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
    end

  def handle_call({:location, location}, _from, state) do
    case Worker.get_temperature(location) do
      {:ok, temp} ->
        new_state = update_state(state, location)
        {:reply, "#{temp}°C", new_state}
      what ->
        IO.inspect(what)
        {:reply, :error, state}
    end
  end

  defp update_state(old_state, location) do
    case Map.has_key?(old_state, location) do
      true ->
        Map.update!(old_state, location, &(&1 + 1))
      false ->
        Map.put_new(old_state, location, 1)
    end
  end
end
