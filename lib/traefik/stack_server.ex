defmodule Traefik.StackServer do
  # Client API
  def start do
    IO.puts("🌤 Starts the Server")
    spawn(__MODULE__, :loop, [[]])
  end

  def put(pid, element) do
    send(pid, {self(), :put, element})
  end

  def get(pid) do
    send(pid, {self(), :get})

    receive do
      {:result, stack} -> stack
    end
  end

  # Server API
  def loop(state) do
    receive do
      {_caller, :put, elem} ->
        loop([elem | state])

      {caller, :get} ->
        send(caller, {:result, state})
        loop(state)

      {caller, :pop} ->
        [pop | state] = state
        send(caller, {:result, pop})
        loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        loop(state)
    end
  end
end
