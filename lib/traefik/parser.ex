defmodule Traefik.Parser do
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Traefik.Conn{method: method, path: path, response: "", status: nil}
  end
end
