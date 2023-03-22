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

  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/developers") do
    %{conn | response: "Hello MakingDevs"}
  end

  def route(conn, "GET", "/projects") do
    %{conn | response: "Traefik, Agora, Domino"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Lenght: #{String.length(conn.response)}

    #{conn.response}
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

request = """
GET /projects HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
GET /developers/1 HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
GET /bugme HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)
