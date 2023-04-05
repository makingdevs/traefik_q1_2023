defmodule Traefik.GenericServer do
  def start(module, state, name) do
    IO.puts("🌤 Starts the Server: #{inspect(module)}")
    pid = spawn(__MODULE__, :loop, [module, state])
    Process.register(pid, name)
    pid
  end

  def loop(module, state) do
    receive do
      {caller, :call, msg} ->
        {:reply, result, state} = module.handle_call(msg, caller, state)
        send(caller, {:result, result})
        loop(module, state)

      {:cast, msg} ->
        {:noreply, state} = module.handle_cast(msg, state)
        loop(module, state)
    end
  end
end
