defmodule Traefik.DeveloperController do
  alias Traefik.{Conn, Developer, Organization}

  @template_path Path.expand("../../templates", __DIR__)

  def index(%Conn{} = conn, _params \\ %{}) do
    developers =
      Organization.list_developers()
      |> Enum.filter(&Developer.filter_male_female/1)
      |> Enum.sort(&Developer.sort_by_last_name/2)
      |> Enum.take(10)

    render(conn, "index.eex", developers: developers)
  end

  def show(%Conn{} = conn, %{"id" => id} = _params) do
    developer = Organization.get_developer(id)

    render(conn, "show.eex", developer: developer)
  end

  def create(%Conn{} = conn, params) do
    response = """
    Created dev:
    #{params["name"]} - #{params["lastname"]} - #{params["email"]}
    """

    %Conn{conn | status: 201, response: response}
  end

  def render(%Conn{} = conn, template, items \\ []) do
    content =
      @template_path
      |> Path.join(template)
      |> EEx.eval_file(items)

    %Conn{conn | status: 200, response: content}
  end
end
