defmodule Traefik.FibonacciServer do
  def compute(n) do
    n
  end

  def get(n) do
    n
  end

  def sequence do
    []
  end

  def handle_call({:get, n}, _sender, state) do
    result = state |> Map.get(n)
    {:reply, result, state}
  end

  def handle_call({:all}, _sender, state) do
    {:reply, state, state}
  end

  def handle_cast({:compute, n}, state) do
    result = Traefik.Fibonacci.sequence(n)
    state = state |> Map.put_new(n, result)
    {:noreply, state}
  end
end
