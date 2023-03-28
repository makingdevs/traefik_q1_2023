defmodule Traefik.DeveloperController do
  def index(conn) do
    developers = Traefik.Organization.list_developers()
    response = "#{inspect(developers)}"
    %{conn | status: 200, response: response}
  end

  def show(conn, _params) do
    %{conn | status: 200, response: "ONE DEVELOPER"}
  end
end
