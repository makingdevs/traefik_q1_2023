defmodule Traefik.DeveloperController do
  def index(conn) do
    response =
      Traefik.Organization.list_developers()
      |> Enum.filter(fn d -> d.gender != "Female" && d.gender != "Male" end)
      |> Enum.sort(fn d1, d2 -> d1.last_name < d2.last_name end)
      |> Enum.take(10)
      |> Enum.map(fn d -> "<li>#{d.id} #{d.first_name} #{d.last_name} #{d.gender}<li>\n" end)

    %{conn | status: 200, response: "<ul>#{response}</ul>"}
  end

  def show(conn, _params) do
    %{conn | status: 200, response: "ONE DEVELOPER"}
  end
end
