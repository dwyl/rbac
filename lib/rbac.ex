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

      iex> RBAC.transform_role_list_to_string(%{name: "sub", id: 1, revoked: nil})
      "1"

      iex> RBAC.transform_role_list_to_string([%{id: 1, revoked: 1}, %{id: 3}])
      "3"
  """
  def transform_role_list_to_string(roles) when is_list(roles) do
    # remove any roles that have been revoked:
    Enum.filter(roles, fn role ->
      not Map.has_key?(role, :revoked) or is_nil(role.revoked)
    end)
    |> Enum.map_join(",", & &1.id)
  end

  # this guard is meant to return the string form if it's already defined:
  def transform_role_list_to_string(roles) when is_binary(roles) do
    roles
  end

  # if roles is a struct/map then attempt to parse it:
  def transform_role_list_to_string(roles) do
    [Map.delete(roles, :__meta__)] |> transform_role_list_to_string()
  end

  @doc """
  `get_approles/1` fetches the roles for the app
  """
  def get_approles(auth_url, client_id) do
    url = "#{auth_url}/approles/#{client_id}"
    HTTPoison.start()
    HTTPoison.get(url)
    |> parse_body_response()
  end

  @doc """
  `parse_body_response/1` parses the response
  so your app can use the resulting JSON (list of roles).
  """
  @spec parse_body_response({atom, String.t}) :: String.t
  def parse_body_response({:error, err}), do: {:error, err}
  def parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # IO.inspect(body)
    if body == nil do
      {:error, :no_body}
    else # make keys of map atoms for easier access in templates
      {:ok, str_key_map} = Jason.decode(body)
      atom_key_map = Enum.map(str_key_map, fn role ->
        for {key, val} <- role, into: %{},
          do: {String.to_atom(key), val}
      end)
      {:ok, atom_key_map}
    end # https://stackoverflow.com/questions/31990134
  end

end
