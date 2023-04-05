defmodule Traefik.FibonacciServer do
  def start(state \\ %{}) do
    Traefik.GenericServer.start(__MODULE__, state, :fibonacci_generic_server)
  end

  # API client
  def compute(pid, n) do
    Traefik.GenericServer.call(pid, {:compute, n})
  end

  def get(pid, n) do
    Traefik.GenericServer.call(pid, {:get, n})
  end

  def sequence(pid) do
    Traefik.GenericServer.call(pid, {:all})
  end

  # Server side

  def handle_call({:get, n}, _sender, state) do
    result = state |> Map.get(n)
    {:reply, result, state}
  end

  def handle_call({:compute, n}, _sender, state) do
    result = Traefik.Fibonacci.sequence(n)
    new_state = state |> Map.put_new(n, result)
    {:reply, result, new_state}
  end

  def handle_call({:all}, _sender, state) do
    {:reply, state, state}
  end

  def handle_cast({:compute, n}, state) do
    result = Traefik.Fibonacci.sequence(n)
    new_state = state |> Map.put_new(n, result)
    {:noreply, new_state}
  end

  def handle_cast(msg, state) do
    IO.inspect(binding(), label: "HANDLE")
    {:noreply, state}
  end
end
