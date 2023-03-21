defmodule Traefik.Handler do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    conn = %{method: "GET", path: "/developers", response: ""}
  end

  def route(conn) do
    conn = %{method: "GET", path: "/developers", response: "Hello Devs"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Lenght: 41

    @neodevelop, @makingdevs, @elixirlang
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
