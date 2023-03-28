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
end
