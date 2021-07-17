defmodule Metex.Ping do
  def loop do
    receive do
      {sender_pid, :ping} ->
        send(sender_pid, :pong)
      :exit ->
        Process.exit(self(), :normal)
      _ ->
        nil
    end
    loop()
  end
end
