defmodule Traefik.GenericServer do
  def start(module, state, name) do
    IO.puts("🌤 Starts the Server: #{inspect(module)}")
    pid = spawn(__MODULE__, :loop, [module, state])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send(pid, {self(), :call, message})

    receive do
      {:result, result} -> result
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def loop(module, state) do
    receive do
      {caller, :call, msg} ->
        {:reply, result, new_state} = module.handle_call(msg, caller, state)
        send(caller, {:result, result})
        loop(module, new_state)

      {:cast, msg} ->
        {:noreply, new_state} = module.handle_cast(msg, state)
        loop(module, new_state)
    end
  end
end
