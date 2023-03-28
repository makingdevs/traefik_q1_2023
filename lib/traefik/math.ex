defmodule Traefik.Math do
  def kind(e) when is_binary(e), do: e |> String.to_integer() |> kind()
  def kind(e) when is_integer(e) and e < 0, do: :negative
  def kind(e) when is_integer(e) and e > 0, do: :positive
  def kind(e) when is_integer(e), do: :zero
end
