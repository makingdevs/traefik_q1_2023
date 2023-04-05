defmodule Traefik.StackGenServer do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def put(element) do
    GenServer.cast(__MODULE__, {:put, element})
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def pop() do
    GenServer.call(__MODULE__, {:pop})
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
