defmodule RBACTest do
  use ExUnit.Case
  doctest RBAC

  @role_list [
    %{
      desc: "With great power comes great responsibility",
      id: 1,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "superadmin",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc: "Can perform all system administration tasks",
      id: 2,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "admin",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc: "Can view and neutrally moderate any content. Can ban rule-breakers. Cannot delete.",
      id: 3,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "moderator",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc: "Can create any content. Can edit and delete their own content.",
      id: 4,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "creator",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc: "Can comment on content where commenting is available.",
      id: 5,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "commenter",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc:
        "Subscribes for updates e.g. newsletter or content from a specific person. Cannot comment until verified.",
      id: 6,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "subscriber",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    },
    %{
      desc: "Can still login to see their content but cannot perform any other action.",
      id: 7,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "banned",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38]
    }
  ]

  test "transform list of maps to comma separated string" do
    list = RBAC.transform_role_list_to_string(@role_list)
    assert list == "1,2,3,4,5,6,7"
  end

  test "return string unmodified" do
    roles = "1,2,3,4,5,6,7"
    assert RBAC.transform_role_list_to_string(roles) == roles
  end

  test "transform_role_list_to_string/1" do
    roles = [
      %{
        __meta__: "#Ecto.Schema.Metadata<:loaded",
        desc: "Subscribes for updates e.g. newsletter",
        id: 6,
        inserted_at: ~N[2020-08-21 16:40:22],
        name: "subscriber",
        person_id: 1,
        updated_at: ~N[2020-08-21 16:40:22]
      }
    ]

    assert RBAC.transform_role_list_to_string(roles) == "6"
  end

  test "get_approles/2 loads the list of roles for an app" do
    auth_url = "https://dwylauth.herokuapp.com"
    client_id = AuthPlug.Token.client_id()
    {:ok, roles} = RBAC.get_approles(auth_url, client_id)
    assert length(roles) > 7
  end

  test "init_roles/2 inserts roles list into ETS cache" do
    auth_url = "https://dwylauth.herokuapp.com"
    client_id = AuthPlug.Token.client_id()
    RBAC.init_roles_cache(auth_url, client_id)

    #  confirm full roles inserted
    {_, list} = :ets.lookup(:roles_cache, "roles") |> List.first()
    assert length(list) == 9

    # lookup role by id:
    role = RBAC.get_role_from_cache(1)
    assert role.name == "superadmin"

    # lookup role by name:
    role = RBAC.get_role_from_cache("admin")
    assert role.id == 2
  end

  # init_cache test helper function
  def init do
    auth_url = "https://dwylauth.herokuapp.com"
    client_id = AuthPlug.Token.client_id()
    RBAC.init_roles_cache(auth_url, client_id)
  end

  test "get_role_from_cache/1 cache miss (unhappy path)" do
    init()
    # attempt to get a non-existent role:
    fail = RBAC.get_role_from_cache("fail")
    assert fail.id == 0
  end

  test "RBAC.has_role?/1 returns boolean true/false" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "1"
        }
      }
    }

    assert RBAC.has_role?(fake_conn, "superadmin")
  end

  test "RBAC.has_role?/1 returns false when doesn't have role" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "1,2,3"
        }
      }
    }

    assert not RBAC.has_role?(fake_conn, "non_existent_role")
  end


  test "RBAC.has_role?/1 works with integers too!" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "1,2,3"
        }
      }
    }

    assert RBAC.has_role?(fake_conn, 3)
  end

  test "RBAC.has_role_any?/1 checks if person has any of the roles" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "1,2,3"
        }
      }
    }

   assert RBAC.has_role_any?(fake_conn, [4, 5, 3])
  end

  test "RBAC.has_role_any?/1 returns false if person doesn't have any of the roles" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "3,4,5"
        }
      }
    }
    # should not have role
    assert not RBAC.has_role_any?(fake_conn, [2, 8, 6])
  end

  test "RBAC.has_role_any?/1 works with list of strings" do
    init()

    fake_conn = %{
      assigns: %{
        person: %{
          roles: "3,4,5"
        }
      }
    }
    # should not have role
    assert RBAC.has_role_any?(fake_conn, ["admin", "commenter", "blah"])
  end
end
