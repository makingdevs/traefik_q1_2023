defmodule Traefik.StackServer do
  @name :stack_server
  # Client API
  def start do
    IO.puts("🌤 Starts the Server: #{inspect(__MODULE__)}")
    pid = spawn(__MODULE__, :loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def put(element) do
    send(@name, {self(), :put, element})
  end

  def get() do
    send(@name, {self(), :get})

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

_pid = Traefik.StackServer.start()
