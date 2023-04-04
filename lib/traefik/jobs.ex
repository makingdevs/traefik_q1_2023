defmodule Traefik.Jobs do
  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {:ok, self(), fun.()}) end)
  end

  def await(pid) do
    receive do
      {:ok, ^pid, r} -> r
    end
  end
end
