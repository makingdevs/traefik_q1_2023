defmodule Traefik.StackServer do
  def start(state \\ []) do
    Traefik.GenericServer.start(__MODULE__, state, :fibonacci_generic_server)
  end

  def put(pid, element) do
    Traefik.GenericServer.cast(pid, {:put, element})
  end

  def get(pid) do
    Traefik.GenericServer.call(pid, {:get})
  end

  def pop(pid) do
    Traefik.GenericServer.call(pid, {:pop})
  end

  def handle_call({:get}, _sender, state) do
    {:reply, state, state}
  end

  def handle_call({:pop}, _sender, [h | state]) do
    {:reply, h, state}
  end

  def handle_cast({:put, elem}, state) do
    {:noreply, [elem | state]}
  end
end
