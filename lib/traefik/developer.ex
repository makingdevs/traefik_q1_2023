defmodule Traefik.Developer do
  defstruct id: 0, first_name: "", last_name: "", email: "", gender: "", ip_address: ""

  def dev_from_list([id, first_name, last_name, email, gender, ip_address]) do
    %__MODULE__{
      id: String.to_integer(id),
      first_name: first_name,
      last_name: last_name,
      email: email,
      gender: gender,
      ip_address: ip_address
    }
  end
end
