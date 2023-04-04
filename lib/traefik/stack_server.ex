defmodule Traefik.StackServer do
  def loop(state) do
    receive do
      {_caller, :put, elem} ->
        loop([elem | state])

      {caller, :get} ->
        send(caller, {:result, state})
        loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        loop(state)
    end
  end
end
