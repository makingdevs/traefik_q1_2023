defmodule Traefik.Handler do
  @moduledoc """
  Handles the request in Traefik WebServer in a simple way.
  """

  @pages_path Path.expand("../../pages", __DIR__)

  import Traefik.Parser, only: [parse: 1]
  import Traefik.Plugs, only: [rewrite_path: 1, track: 1, log: 1]

  alias Traefik.Conn

  @doc "Transforms the request into a response when it's used."
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def route(%Conn{} = conn) do
    route(conn, conn.method, conn.path)
  end

  def route(%Conn{} = conn, "GET", "/secret-projects") do
    %Conn{conn | status: 200, response: "Training for OTP, LiveView, Nx"}
  end

  def route(%Conn{} = conn, "GET", "/developers") do
    %Conn{conn | status: 200, response: "Hello MakingDevs"}
  end

  def route(%Conn{} = conn, "GET", "/developers/" <> id) do
    %Conn{conn | status: 200, response: "Hello developer #{id}"}
  end

  def route(%Conn{} = conn, "GET", "/projects") do
    %Conn{conn | status: 200, response: "Traefik, Agora, Domino"}
  end

  def route(%Conn{} = conn, "GET", "/about") do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%Conn{} = conn, "POST", "/developers") do
    response = """
    Created dev:
    #{conn.params["name"]} - #{conn.params["lastname"]} - #{conn.params["email"]}
    """

    %Conn{conn | status: 201, response: response}
  end

  # def route(conn, "GET", "/about") do
  #   file_path =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file_path) do
  #     {:ok, content} ->
  #       %{conn | status: 200, response: content}

  #     {:error, :enoent} ->
  #       %{conn | status: 404, response: "File not found!!!"}

  #     {:error, reason} ->
  #       %{conn | status: 500, response: "File error: #{reason}"}
  #   end
  # end

  def route(%Conn{} = conn, _, path) do
    %Conn{conn | status: 404, response: "No '#{path}' found"}
  end

  def handle_file({:ok, content}, %Conn{} = conn) do
    %Conn{conn | status: 200, response: content}
  end

  def handle_file({:error, :enoent}, %Conn{} = conn) do
    %Conn{conn | status: 404, response: "File not found!!!"}
  end

  def handle_file({:error, reason}, %Conn{} = conn) do
    %Conn{conn | status: 500, response: "File error: #{reason}"}
  end

  def format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.full_status(conn)}
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

request = """
GET /internal-projects HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
GET /about HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
POST /developers HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 44

name=Juan&lastname=Reyes&email=juan@makingdevs.com
"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
GET /makingdevs HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)

request = """
GET /makingdevs/3 HTTP/1.1
Host: makingdevs.com
User-Agent: MyBrowser/0.1
Accept: */*

"""

response = Traefik.Handler.handle(request)
IO.puts(response)
