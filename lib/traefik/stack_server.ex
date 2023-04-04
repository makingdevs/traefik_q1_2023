defmodule Traefik.StackServer do
  def loop do
    receive do
      {:put, elem} ->
        IO.inspect(elem)

      {:get} ->
        IO.inspect([])

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
    end

    loop()
  end
end
