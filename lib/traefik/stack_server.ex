defmodule Traefik.StackServer do
  def loop do
    receive do
      msg -> msg |> IO.inspect()
    end

    loop()
  end
end
