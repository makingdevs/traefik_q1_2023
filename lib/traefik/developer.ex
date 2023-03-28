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

  def filter_male_female(%__MODULE__{gender: gender} = _developer) do
    gender != "Female" && gender != "Male"
  end

  def sort_by_last_name(%__MODULE__{last_name: ln1}, %__MODULE__{last_name: ln2}) do
    ln1 < ln2
  end

  def format_developer_item(%__MODULE__{} = developer) do
    "<li>#{developer.id} #{developer.first_name} #{developer.last_name} #{developer.gender}<li>\n"
  end

  def format_developer_header(%__MODULE__{} = developer) do
    """
    <h2>#{developer.id} #{developer.first_name}</h2>
    <h3>#{developer.last_name}</h3>
    <h3>#{developer.gender}</h3>
    <h4>Extra salary: #{extra_salary(developer)}</h4>
    """
  end

  def extra_salary(%__MODULE__{gender: g}) when g != "Male" and g != "Female", do: true
  def extra_salary(_), do: false
end
