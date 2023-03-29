defmodule TraefikTest do
  use ExUnit.Case
  doctest Traefik

  test "greets the world" do
    assert Traefik.hello("Juan") == "Hello, Juan"
  end
end
