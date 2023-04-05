defmodule Traefik.FibonacciServer do
  @name :fibonacci_server
  # Client API
  def start do
    IO.puts("🌤 Starts the Server: #{inspect(__MODULE__)}")
    pid = spawn(__MODULE__, :loop, [%{}])
    Process.register(pid, @name)
    pid
  end

  def compute(n) do
    send(@name, {self(), :compute, n})
  end

  def get(n) do
    send(@name, {self(), :get, n})

    receive do
      {:result, stack} -> stack
    end
  end

  def sequence do
    send(@name, {self(), :all})

    receive do
      {:result, stack} -> stack
    end
  end

  # Server API
  def loop(state) do
    receive do
      {_caller, :compute, n} ->
        result = Traefik.Fibonacci.sequence(n)
        state = state |> Map.put_new(n, result)

        loop(state)

      {caller, :get, n} ->
        result = state |> Map.get(n)
        send(caller, {:result, result})
        loop(state)

      {caller, :all} ->
        send(caller, {:result, state})
        loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        loop(state)
    end
  end
end

_pid = Traefik.FibonacciServer.start()
