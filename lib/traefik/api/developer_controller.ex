defmodule Traefik.Api.DeveloperController do
  alias Traefik.Conn

  def index(%Conn{} = conn, params \\ %{limit: 3, offset: 0}) do
    json = Traefik.Organization.list_developers(params) |> Jason.encode!()
    %Conn{conn | status: 200, response: json, content_type: "application/json"}
  end
end
