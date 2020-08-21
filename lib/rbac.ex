defmodule RBAC do
  @moduledoc """
  Documentation for `Rbac`.
  """

  @doc """
  Transform list of maps to comma-separated string of ids.
  """
  def transform_role_list_to_string(role_list) do
    for i <- role_list do
      i.id |> Integer.to_string
    end
    |> Enum.join(",")
  end
end
