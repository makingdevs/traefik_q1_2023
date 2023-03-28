defmodule Traefik.Organization do
  @csv_file Path.expand("../..", __DIR__)

  def list_developers() do
    @csv_file
    |> Path.join("MOCK_DATA.csv")
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Kernel.tl()
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&Traefik.Developer.dev_from_list/1)
  end

  def get_developer(id) when is_binary(id) do
    id |> String.to_integer() |> get_developer()
  end

  def get_developer(id) when is_integer(id) do
    list_developers()
    |> Enum.find(fn dev -> dev.id == id end)
  end
end
