defmodule Traefik.Handler do
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: "", status: nil}
  end

  def rewrite_path(%{path: "/internal-projects"} = conn) do
    %{conn | path: "/secret-projects"}
  end

  def rewrite_path(conn), do: conn

  def track(%{status: 404, path: path} = conn) do
    IO.puts("Warn 💀 #{path} not found!")
    conn
  end

  def track(conn), do: conn

  def log(conn), do: IO.inspect(conn, label: "LOG")

  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/secret-projects") do
    %{conn | status: 200, response: "Training for OTP, LiveView, Nx"}
  end

  def route(conn, "GET", "/developers") do
    %{conn | status: 200, response: "Hello MakingDevs"}
  end

  def route(conn, "GET", "/developers/" <> id) do
    %{conn | status: 200, response: "Hello developer #{id}"}
  end

  def route(conn, "GET", "/projects") do
    %{conn | status: 200, response: "Traefik, Agora, Domino"}
  end

  def route(conn, _, path) do
    %{conn | status: 404, response: "No '#{path}' found"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{code_status(conn.status)}
    Content-Type: text/html
    Content-Lenght: #{String.length(conn.response)}

    #{conn.response}
    """
  end

  defp code_status(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unathorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }
    |> Map.get(code, "Not found")
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

request = """
GET /internal-projects HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)
