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

  def route(%Conn{method: "GET", path: "/fibonacci"} = conn) do
    IO.inspect(self(), label: "SELF")
    pid_1 = Traefik.Jobs.async(fn -> Traefik.Fibonacci.sequence(44) end)
    pid_2 = Traefik.Jobs.async(fn -> Traefik.Fibonacci.sequence(43) end)
    pid_3 = Traefik.Jobs.async(fn -> Traefik.Fibonacci.sequence(42) end)
    pid_4 = Traefik.Jobs.async(fn -> Traefik.Factorial.of_time(50) end)

    r1 = Traefik.Jobs.await(pid_1)
    r2 = Traefik.Jobs.await(pid_2)
    r3 = Traefik.Jobs.await(pid_3)
    r_fac = Traefik.Jobs.await(pid_4)

    results = [r1, r2, r3]

    %Conn{
      conn
      | status: 200,
        response: "Fibonacci: #{inspect(results)}, Factorial: #{r_fac}"
    }
  end

  def route(%Conn{method: "GET", path: "/crash"} = _conn) do
    raise "Crash Traefik Server!!!"
  end

  def route(%Conn{method: "GET", path: "/sleep/" <> time} = conn) do
    time |> String.to_integer() |> :timer.sleep()

    %Conn{conn | status: 200, response: "Awake after #{time} ms."}
  end

  def route(%Conn{method: "GET", path: "/secret-projects"} = conn) do
    %Conn{conn | status: 200, response: "Training for OTP, LiveView, Nx"}
  end

  def route(%Conn{method: "GET", path: "/developers"} = conn) do
    %Conn{conn | status: 200, response: "Hello MakingDevs"}
  end

  def route(%Conn{method: "GET", path: "/developers/" <> id} = conn) do
    %Conn{conn | status: 200, response: "Hello developer #{id}"}
  end

  def route(%Conn{method: "GET", path: "/projects"} = conn) do
    %Conn{conn | status: 200, response: "Traefik, Agora, Domino"}
  end

  def route(%Conn{method: "GET", path: "/makingdevs"} = conn) do
    Traefik.DeveloperController.index(conn)
  end

  def route(%Conn{method: "GET", path: "/makingdevs/" <> id} = conn) do
    params = conn.params |> Map.put("id", id)
    Traefik.DeveloperController.show(conn, params)
  end

  def route(%Conn{method: "GET", path: "/about"} = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%Conn{method: "POST", path: "/developers"} = conn) do
    Traefik.DeveloperController.create(conn, conn.params)
  end

  def route(%Conn{method: "GET", path: "/api/developers"} = conn) do
    Traefik.Api.DeveloperController.index(conn)
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

  def route(%Conn{method: _, path: path} = conn) do
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
    Content-Type: #{conn.content_type}
    Content-Lenght: #{String.length(conn.response)}

    #{conn.response}
    """
  end
end
