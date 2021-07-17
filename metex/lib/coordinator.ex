defmodule Metex.Coordinator do
  def loop(results \\[], max_call_stack_count) do
    receive do
      {:ok, result} ->
        new_results = [result | results]
        if max_call_stack_count == Enum.count(new_results) do
          send self, :exit
        end

        loop(new_results, max_call_stack_count)
      :exit ->
        IO.puts(results |> Enum.sort() |> Enum.join(", "))
      _ ->
        # Ignore unknowns
        loop(results, max_call_stack_count)
      end
    end
end
