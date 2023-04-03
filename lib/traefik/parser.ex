defmodule Traefik.Parser do
  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")

    [request_line | headers_string] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    params = parse_params_string(params_string)

    headers = parse_headers(headers_string, %{})

    %Traefik.Conn{
      method: method,
      path: path,
      response: "",
      status: nil,
      params: params,
      headers: headers
    }
  end

  @doc """
  Given a params in string on the form 'key1=value1&key2=value2', transforms
  those params into a map

  ## Examples
      iex> params_string = "foo=bar&zoo=boo&coo=hoo"
      iex> Traefik.Parser.parse_params_string(params_string)
      %{"foo" => "bar", "zoo" => "boo", "coo" => "hoo"}
      iex> Traefik.Parser.parse_params_string("")
      %{}
  """
  def parse_params_string(params_string), do: String.trim(params_string) |> URI.decode_query()

  @doc """
  Parse a list of string headers into a map, in the form of ["Foo: Bar", "Date: 01/01/01"]
  then transforms into a map with those keys and values

  ## Example
      iex> headers_string = ["Foo: Bar", "Date: 01/01/01"]
      iex> Traefik.Parser.parse_headers(headers_string, %{})
      %{"Foo" => "Bar", "Date" => "01/01/01"}
      iex> Traefik.Parser.parse_headers([], %{})
      %{}
  """
  def parse_headers([], headers), do: headers

  def parse_headers([header_string | rest], headers) do
    [key_header, value_header] = String.split(header_string, ": ")
    headers = Map.put(headers, key_header, value_header)
    parse_headers(rest, headers)
  end
end
