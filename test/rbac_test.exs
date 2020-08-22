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
    },
    %{
      desc: "With great power comes great responsibility",
      id: 8,
      inserted_at: ~N[2020-08-19 10:04:38],
      name: "superadmin",
      person_id: 1,
      updated_at: ~N[2020-08-19 10:04:38],
      revoked: ~N[2020-08-19 10:04:38]
    },
  ]

  test "transform list of maps to comma separated string" do
    list = RBAC.transform_role_list_to_string(@role_list)
    assert list == "1,2,3,4,5,6,7"
  end

  test "return string unmodified" do
    roles = "1,2,3,4,5,6,7"
    assert RBAC.transform_role_list_to_string(roles) == roles
  end

  test "this" do
    roles = %{
      __meta__: "#Ecto.Schema.Metadata<:loaded",
      desc: "Subscribes for updates e.g. newsletter",
      id: 6,
      inserted_at: ~N[2020-08-21 16:40:22],
      name: "subscriber",
      person_id: 1,
      updated_at: ~N[2020-08-21 16:40:22]
    }

    assert RBAC.transform_role_list_to_string(roles) == "6"
  end
end
