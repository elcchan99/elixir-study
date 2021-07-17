defmodule Metex.Pong do
  def loop do
    receive do
      {sender_pid, :pong} ->
        send(sender_pid, :ping)
      :exit ->
        Process.exit(self(), :normal)
      _ ->
        nil
    end
    loop()
  end
end
