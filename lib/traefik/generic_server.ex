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
        IO.inspect(binding())
        send(caller, {:result, msg})
        loop(module, state)

      {:cast, msg} ->
        IO.inspect(binding())
        loop(module, state)
    end
  end
end
