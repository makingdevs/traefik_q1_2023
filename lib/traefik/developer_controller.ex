defmodule Traefik.DeveloperController do
  alias Traefik.{Conn, Developer, Organization}

  def index(%Conn{} = conn, _params \\ %{}) do
    response =
      Organization.list_developers()
      |> Enum.filter(&Developer.filter_male_female/1)
      |> Enum.sort(&Developer.sort_by_last_name/2)
      |> Enum.take(10)
      |> Enum.map(&Developer.format_developer_item/1)

    %Conn{conn | status: 200, response: "<ul>#{response}</ul>"}
  end

  def show(%Conn{} = conn, %{"id" => id} = _params) do
    developer = Organization.get_developer(id)
    %{conn | status: 200, response: "#{inspect(developer)}"}
  end
end
