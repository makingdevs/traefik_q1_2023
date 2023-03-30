defmodule Traefik.Api.DeveloperController do
  alias Traefik.Conn

  def index(%Conn{} = conn, _ \\ %{}) do
    json = Traefik.Organization.list_developers() |> Jason.encode!()
    %Conn{conn | status: 200, response: json, content_type: "application/json"}
  end
end
