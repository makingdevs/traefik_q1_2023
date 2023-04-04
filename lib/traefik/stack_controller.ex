defmodule Traefik.StackController do
  alias Traefik.Conn

  def index(%Conn{} = conn, _params \\ %{}) do
    result = []
    %Conn{conn | status: 200, response: "#{inspect(result)}"}
  end

  def create(%Conn{} = conn, params) do
    IO.inspect("Put in stack: #{inspect(params)}")
    %Conn{conn | status: 203, response: "OK"}
  end
end
