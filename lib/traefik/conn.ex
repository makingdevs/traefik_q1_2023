defmodule Traefik.Conn do
  defstruct method: "",
            path: "",
            status: nil,
            response: "",
            params: %{},
            headers: %{}

  def full_status(%__MODULE__{} = conn) do
    "#{conn.status} #{code_status(conn.status)}"
  end

  defp code_status(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unathorized",
      403 => "Forbidden",
      404 => "Not found",
      500 => "Internal Server Error"
    }
    |> Map.get(code, "Not found")
  end
end
