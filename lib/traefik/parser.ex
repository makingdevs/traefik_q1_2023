defmodule Traefik.Parser do
  def parse(request) do
    [top, _params_string] = String.split(request, "\n\n")

    [request_line | _headers] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    %Traefik.Conn{method: method, path: path, response: "", status: nil}
  end
end
