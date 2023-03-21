defmodule Traefik.Handler do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: ""}
  end

  def route(_conn) do
    _conn = %{method: "GET", path: "/developers", response: "Hello Devs"}
  end

  def format_response(_conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Lenght: 14

    Hello Devs
    """
  end
end

request = """
GET /developers HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)
