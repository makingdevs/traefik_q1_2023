defmodule Traefik.ParserTest do
  use ExUnit.Case

  alias Traefik.Parser

  test "parse a list of string headers into a map" do
    headers_string = ["Foo: Bar", "Date: 01/01/01"]
    headers = Parser.parse_headers(headers_string, %{})
    assert headers == %{"Foo" => "Bar", "Date" => "01/01/01"}
  end

  test "parse params in string into a map" do
    params_string = "foo=bar&zoo=boo&coo=hoo"
    params = Parser.parse_params_string(params_string)
    assert params = %{"foo" => "bar", "zoo" => "boo", "coo" => "hoo"}
  end
end
