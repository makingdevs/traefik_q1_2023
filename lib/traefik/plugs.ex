defmodule Traefik.Plugs do
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
end
