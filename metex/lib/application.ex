defmodule Metex.Application do
  use Application

  def start(_type, _args) do
    children = []

    opts = []
    Supervisor.start_link(children, opts)
  end
end
