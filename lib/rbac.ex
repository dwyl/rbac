defmodule RBAC do
  @moduledoc """
  Documentation for `Rbac`.
  """
  require Logger

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
  `get_approles/2` fetches the roles for the app
  """
  def get_approles(auth_url, client_id) do
    url = "#{auth_url}/approles/#{client_id}"

    HTTPoison.get(url)
    |> parse_body_response()
  end


  # `parse_body_response/1` parses the response
  # so your app can use the resulting JSON (list of roles).
  defp parse_body_response({:error, err}), do: {:error, err}

  defp parse_body_response({:ok, response}) do
    body = Map.get(response, :body)
    # make keys of map atoms for easier access in templates
    if body == nil do
      {:error, :no_body}
    else
      {:ok, str_key_map} = Jason.decode(body)

      atom_key_map =
        Enum.map(str_key_map, fn role ->
          for {key, val} <- role, into: %{}, do: {String.to_atom(key), val}
        end)

      {:ok, atom_key_map}
    end

    # https://stackoverflow.com/questions/31990134
  end

  @doc """
  `init_roles/2 fetches the list of roles for an app
  from the auth app (auth_url) based on the client_id
  and caches the list in-memory (ETS) for fast access.
  """
  def init_roles_cache(auth_url, client_id) do
    {:ok, roles} = RBAC.get_approles(auth_url, client_id)
    # IO.inspect(roles)
    insert_roles_into_ets(roles)
  end

  @doc """
  `insert_roles_into_ets/1 inserts the list of roles into
  an ETS in-memroy cache for fast access at run-time.
  ETS is a high performance cache included *Free* in Elixir/Erlang.
  See: https://elixir-lang.org/getting-started/mix-otp/ets.html
  and: https://elixirschool.com/en/lessons/specifics/ets
  """
  def insert_roles_into_ets(roles) do
    :ets.new(:roles_cache, [:set, :protected, :named_table])
    # insert full list:
    :ets.insert(:roles_cache, {"roles", roles})
    # insert individual roles for fast lookup:
    Enum.each(roles, fn role ->
      :ets.insert(:roles_cache, {role.name, role})
      :ets.insert(:roles_cache, {role.id, role})
    end)
  end

  @doc """
  `get_role_from_cache/1 retrieves a role from ets cache
  """
  def get_role_from_cache(term) do
    case :ets.lookup(:roles_cache, term) do
      # not found:
      [] -> # :error
        Logger.error("rbac.ex:112 Role not found in ets: #{term} \n#{Exception.format_stacktrace()}")
        %{id: 0}
      # role found extract role:
      [{_term, role}] -> role
    end
  end

  # extract the roles from String and make List of integers
  # e.g: "1,2,3" > [1,2,3]
  defp get_roles_from_string(roles) do
    roles
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # allow role to be an atom for conveinece:
  def has_role?(roles, role) when is_list(roles) and is_atom(role) do
    role = get_role_from_cache(Atom.to_string(role))
    Enum.member?(roles, role.id)
  end

  @doc """
  `has_role?/2 confirms if the person has the given role
  e.g:
  has_role?(conn, "home_admin") > true
  has_role?(conn, "potus") > false
  """
  def has_role?(roles, role_name) when is_list(roles) do
    role = get_role_from_cache(role_name)
    Enum.member?(roles, role.id)
  end

  # accept Plug.Conn as first argument to simply application code
  @doc """
  `has_role?/2 confirms if the person has the given role
  e.g:
  has_role?(conn, "home_admin") > true
  has_role?(conn, "potus") > false
  """
  def has_role?(conn, role_name) when is_map(conn) do
    roles = get_roles_from_string(conn.assigns.person.roles)
    has_role?(roles, role_name)
  end

  @doc """
  `has_role_any/2 checks if the person has any one (or more)
  of the roles listed. Allows multiple roles to access content.
  e.g:
  has_role_any?(conn, ["home_admin", "building_owner") > true
  has_role_any?(conn, ["potus", "el_presidente") > false
  """
  def has_role_any?(roles, roles_list) when is_list(roles) do
    list_ids = Enum.map(roles_list, fn role ->
      role = if is_atom(role), do: Atom.to_string(role), else: role
      r = get_role_from_cache(role)
      r.id
    end)

    # find the first occurence of a role by id:
    found = Enum.find(roles, fn rid ->
      Enum.member?(list_ids, rid)
    end)
    not is_nil(found)
  end

  def has_role_any?(conn, roles_list) when is_map(conn) do
    roles = get_roles_from_string(conn.assigns.person.roles)
    has_role_any?(roles, roles_list)
  end
end
