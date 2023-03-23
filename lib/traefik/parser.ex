defmodule Traefik.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | headers_string] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    params = String.trim(params_string) |> URI.decode_query()

    headers = parse_headers(headers_string, 0)

    %Traefik.Conn{
      method: method,
      path: path,
      response: "",
      status: nil,
      params: params
    }
  end

  def parse_headers([], contador), do: contador

  def parse_headers([_ | t], contador) do
    parse_headers(t, contador + 1)
  end
end
