defmodule Traefik.StackServer do
  def loop(state) do
    receive do
      {:put, elem} ->
        loop([elem | state])

      {:get} ->
        IO.inspect(state)
        loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        loop(state)
    end
  end
end
