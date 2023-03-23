defmodule Traefik.Factorial do
  def of(0), do: 1
  def of(n), do: n * of(n - 1)

  def of_2(0, r), do: r
  def of_2(n, r), do: of_2(n - 1, r * n)
end
