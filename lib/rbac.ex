defmodule RBAC do
  @moduledoc """
  Documentation for `Rbac`.
  """

  @doc """
  Transform a list of maps (roles) to comma-separated string of ids.

  ## Examples

      iex> RBAC.transform_role_list_to_string([%{id: 1}, %{id: 2}, %{id: 3}])
      "1,2,3"

      iex> RBAC.transform_role_list_to_string("1,2,3")
      "1,2,3"

      iex> RBAC.transform_role_list_to_string(%{name: "subscriber", id: 1})
      "1"
  """
  def transform_role_list_to_string(roles) when is_list(roles) do
    Enum.map_join(roles, ",", &(&1.id))
  end

  # this guard is meant to return the string form if it's already defined:
  def transform_role_list_to_string(roles) when is_binary(roles) do
    roles
  end

  # if roles is a struct/map then attempt to parse it:
  def transform_role_list_to_string(roles) do
    [ Map.delete(roles, :__meta__) ] |> transform_role_list_to_string()
  end
end
