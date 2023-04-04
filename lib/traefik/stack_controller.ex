defmodule Traefik.StackController do
  alias Traefik.Conn

  def index(%Conn{} = conn, _params \\ %{}) do
    result = Traefik.StackServer.get()
    %Conn{conn | status: 200, response: "#{inspect(result)}"}
  end

  def create(%Conn{} = conn, params) do
    IO.inspect("Put in stack: #{inspect(params)}")

    Traefik.StackServer.put(params["value"])
    %Conn{conn | status: 203, response: "OK"}
  end
end
